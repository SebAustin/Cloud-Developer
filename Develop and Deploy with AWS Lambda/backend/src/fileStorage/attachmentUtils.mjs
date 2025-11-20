import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3'
import { getSignedUrl } from '@aws-sdk/s3-request-presigner'
import AWSXRay from 'aws-xray-sdk-core'
import { createLogger } from '../utils/logger.mjs'

const logger = createLogger('AttachmentUtils')

export class AttachmentUtils {
  constructor(
    s3Client = createS3Client(),
    bucketName = process.env.ATTACHMENTS_S3_BUCKET,
    urlExpiration = parseInt(process.env.SIGNED_URL_EXPIRATION)
  ) {
    this.s3Client = s3Client
    this.bucketName = bucketName
    this.urlExpiration = urlExpiration
  }

  async getUploadUrl(todoId) {
    logger.info('Generating upload URL', { todoId })

    const command = new PutObjectCommand({
      Bucket: this.bucketName,
      Key: todoId
    })

    const uploadUrl = await getSignedUrl(this.s3Client, command, {
      expiresIn: this.urlExpiration
    })

    logger.info('Upload URL generated successfully', { todoId })
    
    return uploadUrl
  }

  getAttachmentUrl(todoId) {
    const attachmentUrl = `https://${this.bucketName}.s3.amazonaws.com/${todoId}`
    logger.info('Generated attachment URL', { todoId, attachmentUrl })
    
    return attachmentUrl
  }
}

function createS3Client() {
  const client = new S3Client({})
  const xrayClient = AWSXRay.captureAWSv3Client(client)
  return xrayClient
}

