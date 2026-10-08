import { Component, inject, signal } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { 
  AuthService
} from '../../core/services/auth.service';
import { TaskService } from '../../core/services/task.service';
import {
  TaskStatus,
  TaskStatusLabels, 
  Task,
  AuthenticatedUser
} from '../../core/models/task.model';
import { HttpErrorResponse } from '@angular/common/http';
import { MatSnackBar } from '@angular/material/snack-bar';
import { getHttpErrorMessage } from '../../core/interceptors/http-error.interceptor';
import { finalize } from 'rxjs';
import { DatePipe } from '@angular/common';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { TaskAppUtils } from '../../core/shared/app.task.utils';

const MAX_REGISTER = 5;

@Component({
  imports: [
    MatButtonModule,
    MatIconModule,
    RouterLink
],
  selector: 'app-dashboard',
  styleUrl: './dashboard.scss',
  templateUrl: './dashboard.html',
})
export class Dashboard {
  protected readonly snackBar = inject(MatSnackBar);
  protected loading = signal(false); 

  private readonly authService = inject(AuthService);
  private readonly taskService = inject(TaskService);
  private tasks: Task[] = [];
  private readonly statusIcons: Record<TaskStatus, string> = {
    [TaskStatus.Pending]: 'schedule',
    [TaskStatus.InProgress]: 'timelapse',
    [TaskStatus.Completed]: 'task_alt',
    [TaskStatus.Cancelled]: 'update_disabled'
};

  constructor() { 
    this.loadTasks();
  }

  get authenticatedUser(): AuthenticatedUser | null {
    return this.authService.authenticatedUser;
  };
  get total(): number { return this.tasks.length; }  
  get pending(): number { return  this.getTotalByStauts(TaskStatus.Pending); };
  get inProgress(): number { return  this.getTotalByStauts(TaskStatus.InProgress); };
  get completed(): number { return this.getTotalByStauts(TaskStatus.Completed); };
  get cancelled(): number { return  this.getTotalByStauts(TaskStatus.Cancelled); };
  get recentTasks(): Task[] {
    return [...this.tasks]
      .filter(t => !([TaskStatus.Completed, TaskStatus.Cancelled]).includes(t.status))
      .sort((a, b) =>
        b.createdAt.localeCompare(a.createdAt)
      ).slice(0, MAX_REGISTER);
  }
  
  dateToString(date: string | null | undefined): string {
    if (!date) return '-';

    const dateValue = TaskAppUtils.convertDateToString(date, 'dd/MMM - yyyy', false);
    return dateValue;
  }

  maxRegister(): number { return MAX_REGISTER };

  statusLabel(status: TaskStatus): string {
    return TaskStatusLabels[status];
  }

  statusIcon(status: TaskStatus): string {
    return this.statusIcons[status];
  }

  private loadTasks() {
    if (this.loading()) return;

    this.setLoading(true);
    this.taskService.listAll(this.authService.authenticatedUser?.id!)
      .pipe(
        finalize(() => this.setLoading(false))
      )
      .subscribe({
        next: (response) => this.tasks = response.data ?? [],
        error: (error: HttpErrorResponse) => {          
          this.setLoading(false);
          this.snackBar.open(getHttpErrorMessage(error), 'Fechar', { duration: 3000 });
        }
      });
  }

  private setLoading(value: boolean) {
    this.loading.set(value);
  }

  private getTotalByStauts(status: TaskStatus): number{
    if (!this.tasks) return 0;

    return this.tasks.filter(
      task => task.status === status
    ).length;
  }
}
