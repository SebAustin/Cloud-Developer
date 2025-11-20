import Axios from 'axios'
import jsonwebtoken from 'jsonwebtoken'
import { createLogger } from '../../utils/logger.mjs'

const logger = createLogger('auth')

// Auth0 domain configuration
const jwksUrl = 'https://dataviz.auth0.com/.well-known/jwks.json'

let cachedCertificate = null

export async function handler(event) {
  try {
    const jwtToken = await verifyToken(event.authorizationToken)

    return {
      principalId: jwtToken.sub,
      policyDocument: {
        Version: '2012-10-17',
        Statement: [
          {
            Action: 'execute-api:Invoke',
            Effect: 'Allow',
            Resource: '*'
          }
        ]
      }
    }
  } catch (e) {
    logger.error('User not authorized', { error: e.message })

    return {
      principalId: 'user',
      policyDocument: {
        Version: '2012-10-17',
        Statement: [
          {
            Action: 'execute-api:Invoke',
            Effect: 'Deny',
            Resource: '*'
          }
        ]
      }
    }
  }
}

async function verifyToken(authHeader) {
  const token = getToken(authHeader)
  const jwt = jsonwebtoken.decode(token, { complete: true })

  if (!jwt) {
    throw new Error('Invalid token')
  }

  logger.info('Verifying token', { kid: jwt.header.kid })

  const certificate = await getCertificate(jwt.header.kid)
  
  return jsonwebtoken.verify(token, certificate, { algorithms: ['RS256'] })
}

async function getCertificate(kid) {
  if (cachedCertificate) {
    logger.info('Using cached certificate')
    return cachedCertificate
  }

  logger.info('Fetching certificate from Auth0', { jwksUrl })

  try {
    const response = await Axios.get(jwksUrl)
    const keys = response.data.keys

    if (!keys || keys.length === 0) {
      throw new Error('No keys found in JWKS')
    }

    const signingKeys = keys.filter(
      key =>
        key.use === 'sig' &&
        key.kty === 'RSA' &&
        key.kid &&
        key.x5c &&
        key.x5c.length
    )

    if (!signingKeys.length) {
      throw new Error('No signing keys found in JWKS')
    }

    const signingKey = signingKeys.find(key => key.kid === kid)

    if (!signingKey) {
      throw new Error(`Unable to find signing key with kid: ${kid}`)
    }

    const certificate = certToPEM(signingKey.x5c[0])
    cachedCertificate = certificate

    logger.info('Certificate fetched and cached successfully')

    return certificate
  } catch (error) {
    logger.error('Failed to fetch certificate', { error: error.message })
    throw new Error('Failed to fetch certificate')
  }
}

function certToPEM(cert) {
  cert = cert.match(/.{1,64}/g).join('\n')
  cert = `-----BEGIN CERTIFICATE-----\n${cert}\n-----END CERTIFICATE-----\n`
  return cert
}

function getToken(authHeader) {
  if (!authHeader) throw new Error('No authentication header')

  if (!authHeader.toLowerCase().startsWith('bearer '))
    throw new Error('Invalid authentication header')

  const split = authHeader.split(' ')
  const token = split[1]

  return token
}
