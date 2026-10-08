import {
  Task,
  TaskApiReponse,
  TaskPriority,
  TaskStatus 
} from "./task.model";

export class TaskMapper {
  static toDomain(apiResponse: TaskApiReponse): Task {
    return {
      id: apiResponse.id,
      userId: apiResponse.id_usuario,
      title: apiResponse.titulo,
      description: apiResponse.descricao,
      priority: apiResponse.prioridade as TaskPriority,
      status: apiResponse.status as TaskStatus,
      createdAt: apiResponse.data_hora_incluido,
      updatedAt: apiResponse.data_hora_alterado,
      completedAt: apiResponse.data_hora_completado,
      cancelledAt: apiResponse.data_hora_cancelado,
      userEmail: apiResponse.e_mail_usuario
    }
  }
}