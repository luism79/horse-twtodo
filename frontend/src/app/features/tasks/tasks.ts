import { 
  Component,
  inject,
  signal,
  ViewChild,
  Inject
 } from '@angular/core';
import { DatePipe, NgForOf } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatTooltipModule } from '@angular/material/tooltip';
import { 
  MatPaginator,
  MatPaginatorIntl,
  MatPaginatorModule,
  PageEvent
} from '@angular/material/paginator';
import { 
  MatTableModule,
  MatTableDataSource
} from '@angular/material/table';
import { TaskService } from '../../core/services/task.service';
import { AuthService } from '../../core/services/auth.service';

import { 
  Task,
  TASK_PRIORITIES,
  TASK_STATUSES,
  TaskInputDTO,
  TaskPriority,
  TaskPriorityLabels, 
  TaskStatus,
  TaskStatusLabels
} from '../../core/models/task.model';
import { debounceTime, distinctUntilChanged, finalize, throwError } from 'rxjs';
import { HttpErrorResponse } from '@angular/common/http';
import { MatSnackBar } from '@angular/material/snack-bar';
import { getHttpErrorMessage } from '../../core/interceptors/http-error.interceptor';
import {
  FormControl,
  NonNullableFormBuilder,
  ReactiveFormsModule,
  Validators
} from '@angular/forms';
import { TaskAppUtils } from '../../core/shared/app.task.utils';
import { MAT_DIALOG_DATA, MatDialog, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { MatSelectModule } from '@angular/material/select';

const ELEMENT_COLUMNS: string[] = [
  'title',
  'priority',
  'status',
  'createdAt',
  'dateModifiedAt',
  'actions'
];

@Component({
  imports: [
    MatIconModule,
    MatButtonModule,
    MatCardModule,
    MatInputModule,
    MatFormFieldModule,
    MatProgressSpinnerModule,
    MatTableModule,
    MatPaginatorModule,
    MatTooltipModule,
    ReactiveFormsModule
],
  selector: 'app-tasks',
  styleUrl: './tasks.scss',
  templateUrl: './tasks.html',
})
export class Tasks {
   @ViewChild(MatPaginator)
   set paginator(paginator: MatPaginator) {
    this.dataSource.paginator = paginator;
   };

  protected deletingId: string | null = null;
  protected loading = signal(false);
  protected readonly dataSource = new MatTableDataSource<Task>();
  protected readonly displayedColumns = ELEMENT_COLUMNS;
  protected readonly searchControl = new FormControl('', { nonNullable: true });
  protected readonly pageSizeOptions = signal([5, 10, 25, 50]);
  protected readonly pageSize = signal(5);
  protected readonly pageIndex = signal(0);
  protected pageEvent = signal<PageEvent | undefined>(undefined);
  protected selectedStatus: TaskStatus | null = null;
  protected selectesPriority: TaskPriority | null = null;
  protected readonly statuses = [
    TaskStatus.Pending,
    TaskStatus.InProgress,
    TaskStatus.Completed,
    TaskStatus.Cancelled
  ];

  protected readonly priorities = [
    TaskPriority.High,
    TaskPriority.Low,
    TaskPriority.Medium
  ];

  private readonly paginatorIntl = inject(MatPaginatorIntl);
  private readonly taskService = inject(TaskService);
  private readonly authService = inject(AuthService);
  private readonly snackBar = inject(MatSnackBar);
  private readonly dialog = inject(MatDialog);

  constructor() {
    this.loadPaginatorIntl();
    this.loadSearchFilter();
    this.loadTasks(); 
  }

  handlePageEvent(e: PageEvent) {
    this.pageEvent.set(e);
    this.pageSize.set(e.pageSize);
    this.pageIndex.set(e.pageIndex);
  }

  activeTask(status: TaskStatus): boolean {
    return ([TaskStatus.InProgress, TaskStatus.Pending]).includes(status);
  }

  dataStatusFilter(status: TaskStatus | null) {
    this.selectedStatus = status;
    this.applyFilters();
  }

  dataPriorityFilter(priority: TaskPriority | null) {
    this.selectesPriority = priority;
    this.applyFilters();
  }

  dateToString(date: string | null | undefined): string {
    if (!date) return '-';

    const dateValue = TaskAppUtils.convertDateToString(date, 'dd/MMM - yyyy', false);
    return dateValue;
  }

  dateTaskToString(task: Task): string {
    let value = '-';
    if (task.status === TaskStatus.Completed)
      value = `Concluído em ${this.dateToString(task.completedAt)}`;
    else
      value = !!task.updatedAt ? `Alterado em ${this.dateToString(task.updatedAt)}` : '-';

    return value;
  }

  deleteTask(task: Task) {
    const ref = this.dialog.open(TaskDeleteDialogComponent, {
      width: 'min(420px, calc(100vw - 28px))',
      data: task
    });

    ref.afterClosed().subscribe((confirmed: boolean) => {
      if (!confirmed) return;

      this.deletingId = task.id;
      this.taskService.remove(task.id).pipe(
        finalize(() => this.deletingId = null))
          .subscribe({
            next: () => { this.snackBar.open('Tarefa excluída.', 'Fechar', { duration: 3000 }); this.loadTasks(); },
             error: (error: HttpErrorResponse) => this.snackBar.open(getHttpErrorMessage(error), 'Fechar', { duration: 3000 })
      });
    });
  }

  isCompleted(status: TaskStatus): boolean {
    return status === TaskStatus.Completed;
  }

  isEmpty(): boolean {
    return (this.totalItems() === 0);
  }

  totalItems(): number {
    return this.dataSource.filteredData.length;
  }

  openTask(task?: Task) {
    const ref = this.dialog.open(
        TaskDialogComponent,
        { 
          width: 'min(520px, calc(100vw - 28px))',
          data: task
        }
      );

    ref.afterClosed()
      .subscribe((input: TaskInputDTO) => {
        if (!input) return;

        const request = task ? this.taskService.update(task.id, input) : this.taskService.add(input);

        request
          .subscribe({
            next: () => {
              this.snackBar.open(task ? 'Tarefa atualizada.' : 'Tarefa criada.', 'Fechar', { duration: 3000 });
              this.loadTasks();
            },
            error: (error: HttpErrorResponse) => this.snackBar.open(getHttpErrorMessage(error), 'Fechar', { duration: 3000 })
          });
      });
  }

  priorityLabel(priority: TaskPriority): string {
    return TaskPriorityLabels[priority];
  }

  statusLabel(status: TaskStatus): string {
    return TaskStatusLabels[status];
  }

  viewTask(task: Task) {
    this.dialog.open(
      TaskDetailsDialogComponent,
      { 
        width: 'min(520px, calc(100vw - 28px))',
        data: task
      }
    );
  }

  private loadPaginatorIntl() {
    this.paginatorIntl.itemsPerPageLabel = 'Itens por página:';
    this.paginatorIntl.nextPageLabel = 'Próxima página';
    this.paginatorIntl.previousPageLabel = 'Página anterior';
    this.paginatorIntl.firstPageLabel = 'Primeira página';
    this.paginatorIntl.lastPageLabel = 'Última página';

    this.paginatorIntl.getRangeLabel = (
      page: number,
      pageSize: number,
      length: number
    ) => {      
      const startIndex = page * pageSize;
      const endIndex = Math.min(startIndex + pageSize, length);

      return `${startIndex + 1} – ${endIndex} de ${length}`;
    };
    this.paginatorIntl.changes.next();
  }

  private loadSearchFilter() {
    this.dataSource.filterPredicate = (task, filter) => {
      const criteria = JSON.parse(filter) as {
        search: string;
        status: TaskStatus | null;
        priority: TaskPriority | null;
      };
      
      const matchesText =
        `${task.title ?? ''} ${task.description ?? ''}`
        .toLowerCase().includes(criteria.search);

      const matchesStatus = criteria.status === null || task.status === criteria.status;

      const matchesPrioriry = criteria.priority === null || task.priority === criteria.priority;
      
      return matchesText && matchesStatus && matchesPrioriry;
    }

    this.applyFilters();
 
    this.searchControl.valueChanges
      .pipe(
        debounceTime(300),
        distinctUntilChanged(),
        takeUntilDestroyed()
      )
      .subscribe(() => this.applyFilters());
  }

  private applyFilters() {
    this.dataSource.filter = JSON.stringify({
      search: this.searchControl.value.trim().toLowerCase(),
      status: this.selectedStatus,
      priority: this.selectesPriority
    });
    this.pageIndex.set(0);
    this.dataSource.paginator?.firstPage();
  }

  private loadTasks() {
    if (this.loading()) return;

    this.setLoading(true);

    this.taskService.listAll(
      this.authService.authenticatedUser?.id!
    )
    .pipe(finalize(() => this.setLoading(false)))
    .subscribe({
      next: (res => {
        return this.dataSource.data = res.data.sort((a, b) =>
          b.createdAt.localeCompare(a.createdAt)) ?? [];
      }),
      error: (error: HttpErrorResponse) => {          
          this.setLoading(false);
          this.snackBar.open(getHttpErrorMessage(error), 'Fechar', { duration: 4500 });
        }
    });
  }

  private setLoading(value: boolean) {
    this.loading.set(value);
  }
}

@Component({
  selector: 'app-task-details-dialog',
  imports: [
    DatePipe,
    MatButtonModule,
    MatDialogModule,
    MatIconModule
  ],
  template: `
  <h2 mat-dialog-title>Detalhes da tarefa</h2>
  <mat-dialog-content class="details">
    <div class="detail-date-info">
      <div>
        <dt>Status</dt>
        <dd class="status status-{{ data.status }}">{{ statusLabel(data.status) }}</dd>
      </div>
       <div>        
        <dt>Prioridade</dt>
        <dd class="priority priority-{{ data.priority }}">{{ priorityLabel(data.priority) }}</dd>
      </div>
    </div>
    <h3>{{ data.title }}</h3>
    <p>{{ data.description || 'Sem descrição.' }}</p>
    <dl>
      <div class="detail-date-info">
        <div>
          <dt>Criada em</dt>
          <dd>{{ data.createdAt| date:'dd/MM/yyyy' }}</dd>
        </div>
        <div>
          <dt>{{ dateTitleLabel(data.status) }}</dt>
          <dd>{{ dateInfo(data) }}</dd>
        </div>
      </div>
      <div>
        <dt>Responsável</dt>
        <dd>{{ data.userEmail }}</dd>
      </div>
    </dl>
  </mat-dialog-content>
  <mat-dialog-actions align="end">
    <button mat-button mat-dialog-close>Fechar</button>
  </mat-dialog-actions>
`,
styleUrl: './tasks.scss',
})
export class TaskDetailsDialogComponent {
  constructor(@Inject(MAT_DIALOG_DATA) protected readonly data: Task) {}

  statusLabel(value: number): string { 
    return TASK_STATUSES.find((item) => item.value === value)?.label ?? 'Desconhecido';
  }
  
  priorityLabel(value: number): string {
    return TASK_PRIORITIES.find((item) => item.value === value)?.label ?? 'Desconhecida';
  }

  dateTitleLabel(status: TaskStatus): string {
    if ([TaskStatus.Cancelled, TaskStatus.Completed].includes(status))
      return `${TaskStatusLabels[status]} em`;
    else return 'Alterado em';
  }

  dateInfo(task: Task): string {
    switch (task.status) {
      case TaskStatus.Cancelled:
          return TaskAppUtils.convertDateToString(task.cancelledAt);
      case TaskStatus.Completed:
          return TaskAppUtils.convertDateToString(task.completedAt);
    }
    return TaskAppUtils.convertDateToString(task.updatedAt);
  }
}

@Component({
  selector: 'app-task-delete-dialog',
  imports: [
    MatButtonModule,
    MatDialogModule
  ],
  template: `
    <h2 mat-dialog-title>Excluir tarefa</h2>
    <mat-dialog-content>
      Excluir a tarefa "{{ data.title }}"?
    </mat-dialog-content>
    <mat-dialog-actions align="end">
      <button mat-button mat-dialog-close>Cancelar</button>
      <button mat-flat-button color="warn" (click)="confirm()">Excluir</button>
    </mat-dialog-actions>
  `,
})
export class TaskDeleteDialogComponent {
  constructor(
    private readonly ref: MatDialogRef<TaskDeleteDialogComponent>,
    @Inject(MAT_DIALOG_DATA) protected readonly data: Task,
  ) {}

  confirm(): void {
    this.ref.close(true);
  }
}

@Component({
  selector: 'app-task-dialog',
  imports: [
    ReactiveFormsModule,
    MatButtonModule,
    MatDialogModule,
    MatFormFieldModule,
    MatIconModule,
    MatInputModule,
    MatProgressSpinnerModule,
    MatSelectModule,
  ],
  template: `
    <h2 mat-dialog-title>
      {{ data ? 'Editar tarefa' : 'Nova tarefa' }}
    </h2>

    <mat-dialog-content>
      <form [formGroup]="form" class="task-form">
        <mat-form-field appearance="outline">
          <mat-label>Título</mat-label>
          <input matInput formControlName="title" />
          <mat-error>Informe um título.</mat-error>
        </mat-form-field>

        <mat-form-field appearance="outline">
          <mat-label>Descrição</mat-label>
          <textarea
            matInput
            rows="4"
            formControlName="description"
          ></textarea>
          <mat-error>Informe uma descrição.</mat-error>
        </mat-form-field>

        <div class="form-grid">
          <mat-form-field appearance="outline">
            <mat-label>Prioridade</mat-label>

            <mat-select formControlName="priority">
              @for (priority of priorities; track priority.value
              ) {
                <mat-option [value]="priority.value">
                  {{ priority.label }}
                </mat-option>
              }
            </mat-select>
          </mat-form-field>

          <mat-form-field appearance="outline">
            <mat-label>Status</mat-label>

            <mat-select formControlName="status">
              @for (status of statuses; track status.value
              ) {
                <mat-option [value]="status.value">
                  {{ status.label }}
                </mat-option>
              }
            </mat-select>
          </mat-form-field>
        </div>
      </form>
    </mat-dialog-content>

    <mat-dialog-actions align="end">
      <button mat-button mat-dialog-close>
        Cancelar
      </button>

      <button
        mat-flat-button
        color="primary"
        (click)="save()"
        [disabled]="form.invalid"
      >
        Salvar tarefa
      </button>
    </mat-dialog-actions>
  `,
  styleUrl: './tasks.scss',
})
export class TaskDialogComponent {
  protected readonly priorities = TASK_PRIORITIES;
  protected readonly statuses = TASK_STATUSES;
  protected readonly form;

  private readonly auth = inject(AuthService);

  constructor(
    private readonly ref: MatDialogRef<TaskDialogComponent>,
    @Inject(MAT_DIALOG_DATA)
    protected readonly data: Task | undefined,
    fb: NonNullableFormBuilder,
  ) {
    this.form = fb.group({
      title: [
        data?.title ?? '',
        [
          Validators.required,
          Validators.maxLength(50),
        ],
      ],
      description: [
        data?.description ?? '',
        [
          Validators.required,
          Validators.maxLength(150)
        ]
      ],
      priority: [
        data?.priority ?? TaskPriority.Low,
      ],
      status: [
        data?.status ?? TaskStatus.Pending,
      ],
    });
  }

  save(): void {
    if (this.form.invalid) {
      return;
    }

    const value = this.form.getRawValue();

    this.ref.close({
      id_usuario:
        this.auth.authenticatedUser?.id ??
        '',
      titulo: value.title,
      descricao: value.description,
      prioridade: value.priority,
      status: value.status,
    });
  }
}
