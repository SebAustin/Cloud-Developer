import { v4 as uuidv4 } from 'uuid'
import { TodosAccess } from '../dataLayer/todosAccess.mjs'
import { AttachmentUtils } from '../fileStorage/attachmentUtils.mjs'
import { createLogger } from '../utils/logger.mjs'

const logger = createLogger('TodosBusinessLogic')
const todosAccess = new TodosAccess()
const attachmentUtils = new AttachmentUtils()

export async function createTodo(userId, createTodoRequest) {
  logger.info('Creating todo', { userId, todoName: createTodoRequest.name })

  const todoId = uuidv4()
  const createdAt = new Date().toISOString()

  const newTodo = {
    userId,
    todoId,
    createdAt,
    done: false,
    ...createTodoRequest
  }

  await todosAccess.createTodoItem(newTodo)

  logger.info('Todo created successfully', { todoId })
  
  return newTodo
}

export async function getTodosForUser(userId) {
  logger.info('Getting todos for user', { userId })

  const todos = await todosAccess.getTodosForUser(userId)

  logger.info('Retrieved todos for user', { userId, count: todos.length })
  
  return todos
}

export async function updateTodo(userId, todoId, updateTodoRequest) {
  logger.info('Updating todo', { userId, todoId })

  const updatedTodo = await todosAccess.updateTodoItem(
    userId,
    todoId,
    updateTodoRequest
  )

  logger.info('Todo updated successfully', { todoId })
  
  return updatedTodo
}

export async function deleteTodo(userId, todoId) {
  logger.info('Deleting todo', { userId, todoId })

  await todosAccess.deleteTodoItem(userId, todoId)

  logger.info('Todo deleted successfully', { todoId })
}

export async function createAttachmentPresignedUrl(userId, todoId) {
  logger.info('Creating attachment presigned URL', { userId, todoId })

  const uploadUrl = await attachmentUtils.getUploadUrl(todoId)
  const attachmentUrl = attachmentUtils.getAttachmentUrl(todoId)

  await todosAccess.updateTodoAttachmentUrl(userId, todoId, attachmentUrl)

  logger.info('Presigned URL created and attachment URL updated', { todoId })
  
  return uploadUrl
}

