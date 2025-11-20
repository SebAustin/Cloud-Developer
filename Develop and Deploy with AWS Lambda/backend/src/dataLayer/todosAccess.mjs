import { DynamoDBClient } from '@aws-sdk/client-dynamodb'
import { DynamoDBDocumentClient, QueryCommand, PutCommand, UpdateCommand, DeleteCommand } from '@aws-sdk/lib-dynamodb'
import AWSXRay from 'aws-xray-sdk-core'
import { createLogger } from '../utils/logger.mjs'

const logger = createLogger('TodosAccess')

export class TodosAccess {
  constructor(
    documentClient = createDynamoDBClient(),
    todosTable = process.env.TODOS_TABLE,
    todosIndex = process.env.TODOS_CREATED_AT_INDEX
  ) {
    this.documentClient = documentClient
    this.todosTable = todosTable
    this.todosIndex = todosIndex
  }

  async getTodosForUser(userId) {
    logger.info('Getting all todos for user', { userId })

    const command = new QueryCommand({
      TableName: this.todosTable,
      IndexName: this.todosIndex,
      KeyConditionExpression: 'userId = :userId',
      ExpressionAttributeValues: {
        ':userId': userId
      }
    })

    const result = await this.documentClient.send(command)
    logger.info('Retrieved todos', { count: result.Items.length })
    
    return result.Items
  }

  async createTodoItem(todoItem) {
    logger.info('Creating new todo item', { todoId: todoItem.todoId })

    const command = new PutCommand({
      TableName: this.todosTable,
      Item: todoItem
    })

    await this.documentClient.send(command)
    logger.info('Todo item created successfully', { todoId: todoItem.todoId })
    
    return todoItem
  }

  async updateTodoItem(userId, todoId, updateData) {
    logger.info('Updating todo item', { userId, todoId })

    const updateExpressions = []
    const expressionAttributeNames = {}
    const expressionAttributeValues = {}

    if (updateData.name !== undefined) {
      updateExpressions.push('#name = :name')
      expressionAttributeNames['#name'] = 'name'
      expressionAttributeValues[':name'] = updateData.name
    }

    if (updateData.dueDate !== undefined) {
      updateExpressions.push('dueDate = :dueDate')
      expressionAttributeValues[':dueDate'] = updateData.dueDate
    }

    if (updateData.done !== undefined) {
      updateExpressions.push('done = :done')
      expressionAttributeValues[':done'] = updateData.done
    }

    if (updateExpressions.length === 0) {
      logger.warn('No fields to update')
      return
    }

    const command = new UpdateCommand({
      TableName: this.todosTable,
      Key: {
        userId,
        todoId
      },
      UpdateExpression: 'SET ' + updateExpressions.join(', '),
      ExpressionAttributeNames: Object.keys(expressionAttributeNames).length > 0 ? expressionAttributeNames : undefined,
      ExpressionAttributeValues: expressionAttributeValues,
      ReturnValues: 'ALL_NEW'
    })

    const result = await this.documentClient.send(command)
    logger.info('Todo item updated successfully', { todoId })
    
    return result.Attributes
  }

  async deleteTodoItem(userId, todoId) {
    logger.info('Deleting todo item', { userId, todoId })

    const command = new DeleteCommand({
      TableName: this.todosTable,
      Key: {
        userId,
        todoId
      }
    })

    await this.documentClient.send(command)
    logger.info('Todo item deleted successfully', { todoId })
  }

  async updateTodoAttachmentUrl(userId, todoId, attachmentUrl) {
    logger.info('Updating todo attachment URL', { userId, todoId })

    const command = new UpdateCommand({
      TableName: this.todosTable,
      Key: {
        userId,
        todoId
      },
      UpdateExpression: 'SET attachmentUrl = :attachmentUrl',
      ExpressionAttributeValues: {
        ':attachmentUrl': attachmentUrl
      },
      ReturnValues: 'ALL_NEW'
    })

    const result = await this.documentClient.send(command)
    logger.info('Attachment URL updated successfully', { todoId })
    
    return result.Attributes
  }
}

function createDynamoDBClient() {
  const client = new DynamoDBClient({})
  const xrayClient = AWSXRay.captureAWSv3Client(client)
  return DynamoDBDocumentClient.from(xrayClient)
}

