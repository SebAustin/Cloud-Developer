import middy from '@middy/core'
import cors from '@middy/http-cors'
import httpErrorHandler from '@middy/http-error-handler'
import { getTodosForUser } from '../../businessLogic/todos.mjs'
import { getUserId } from '../utils.mjs'
import { createLogger } from '../../utils/logger.mjs'

const logger = createLogger('getTodos')

export const handler = middy()
  .use(httpErrorHandler())
  .use(
    cors({
      credentials: true
    })
  )
  .handler(async (event) => {
    logger.info('Processing getTodos event', { event })

    const userId = getUserId(event)
    const todos = await getTodosForUser(userId)

    logger.info('Successfully retrieved todos', { userId, count: todos.length })

    return {
      statusCode: 200,
      body: JSON.stringify({
        items: todos
      })
    }
  })
