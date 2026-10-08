export enum TaskPriority {
  Low = 0,
  Medium = 1,
  High = 2
}

export enum TaskStatus {
  Pending = 0,
  InProgress = 1,
  Completed = 2,
  Cancelled = 3
}

export const TaskPriorityLabels: Record<TaskPriority, string> = {
  [TaskPriority.Low]: 'Baixa',
  [TaskPriority.Medium]: 'Média',
  [TaskPriority.High]: 'Alta'
}

export const TaskStatusLabels: Record<TaskStatus, string> = {
  [TaskStatus.Pending]: 'Pendente',
  [TaskStatus.InProgress]: 'Em progresso',
  [TaskStatus.Completed]: 'Concluído',
  [TaskStatus.Cancelled]: 'Cancelado'
}

export interface TaskApiReponse {
  id: string;
  id_usuario: string;
  titulo: string;
  descricao: string;
  prioridade: number;
  status: number;
  data_hora_incluido: string;
  data_hora_alterado: string;
  data_hora_completado: string | null;
  data_hora_cancelado: string | null;
  e_mail_usuario: string;
}

export interface Task {
  id: string;
  userId: string;
  title: string;
  description: string;
  priority: TaskPriority;
  status: TaskStatus;
  createdAt: string;
  updatedAt: string;
  completedAt: string | null;
  cancelledAt: string | null;
  userEmail: string;
}

export interface AuthenticatedUser {
  id: string;
  email: string;
}

export interface LoginInputDTO {
    email: string;
    password: string;
}

export interface TaskInputDTO {
  id_usuario: string;
  titulo: string;
  descricao: string;
  prioridade: TaskPriority;
  status: TaskStatus;
}

export interface LoginApiReponse {
    user_id: string;
    expires_in_minutes: number;
    access_token: string;
}

export interface LoginSession {
    user_id: string;
    email: string;
    expiresInMinutes: number;
    tokenAccess: string;
    loggedAt: string
}

export interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

export const TASK_STATUSES = [
  { value: 0, label: 'Pendente' },
  { value: 1, label: 'Em andamento' },
  { value: 2, label: 'Concluída' },
  { value: 3, label: 'Cancelada' },
] as const;

export const TASK_PRIORITIES = [
  { value: 0, label: 'Baixa' },
  { value: 1, label: 'Média' },
  { value: 2, label: 'Alta' },
] as const;