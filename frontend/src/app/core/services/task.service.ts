import { inject, Injectable } from "@angular/core";
import { map, Observable } from "rxjs";
import { ApiResponse, Task, TaskApiReponse, TaskInputDTO } from "../models/task.model";
import { HttpClient, HttpParams } from "@angular/common/http";
import { environment } from "../../../environments/environment.development";
import { TaskMapper } from "../models/task.mapper";

@Injectable({ providedIn: 'root' })
export class TaskService {
  private readonly http = inject(HttpClient);
  private readonly endpoint = `${environment.apiUrl}/tasks`;

  add(input: TaskInputDTO): Observable<ApiResponse<{ id: string }>> {
    return this.http.post<ApiResponse<{ id: string }>>(this.endpoint, input);
  }

  listAll(user_id: string): Observable<ApiResponse<Task[]>> {
    let params = new HttpParams();

    params = params.set('user-id', user_id);
    return this.http.get<ApiResponse<TaskApiReponse[]>>(this.endpoint, { params })
      .pipe(
          map((response: ApiResponse<TaskApiReponse[]>) => ({
            ...response,
            data: response.data.map(TaskMapper.toDomain)
          }))
      );
  }

  remove(id: string): Observable<ApiResponse<{ id: string }>> {
    return this.http.delete<ApiResponse<{ id: string}>>(`${this.endpoint}/${id}`);
  }

  update(id: string, input: TaskInputDTO): Observable<ApiResponse<{ id: string }>> {
    return this.http.put<ApiResponse<{ id: string }>>(`${this.endpoint}/${id}`, input);
  }
}
