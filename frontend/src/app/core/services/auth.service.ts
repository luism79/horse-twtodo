import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, map, Observable, tap } from 'rxjs';
import { inject, Injectable } from '@angular/core';
import { Router } from '@angular/router';
import {
  LoginInputDTO,
  LoginApiReponse,
  LoginSession,
  ApiResponse,
  AuthenticatedUser
 } from '../models/task.model';
import { environment } from '../../../environments/environment.development';


const STORAGE_KEY = 'auth_session';

@Injectable({ providedIn: 'root'})
export class AuthService {
  protected readonly router = inject(Router);
  protected readonly sessionSubject = new BehaviorSubject<LoginSession|null>(this.loadFromStorage());
  private readonly http = inject(HttpClient);

  clearSession(): void {
    sessionStorage.removeItem(STORAGE_KEY);
    this.sessionSubject.next(null);
  }

  isAuthenticated(): boolean{
    const session = this.sessionSubject.value;
    return Boolean(
      session?.tokenAccess
    );
  }

  login(userLogin: LoginInputDTO): Observable<LoginSession> {
    const payLoad = {'e-mail': userLogin.email, password: userLogin.password};

    return this.http.post<ApiResponse<LoginApiReponse>>(
      `${environment.apiUrl}/auth`,
      payLoad
    )
    .pipe(
      map(res => {
        const resultSession = this.toSession(res.data);
        resultSession.email = userLogin.email;
        return resultSession;
      }),
      tap(session => this.saveSession(session))
    );
  }

  logout() {
    this.clearSession();
    this.router.navigate(['/login']);
  }

  get authenticatedUser(): AuthenticatedUser|null {
    const session = this.sessionSubject.value;
    
    if (!session) return null;

    return {
      id: session.user_id,
      email: session.email,
    };
  }

  get token(): string | null {
    const session = this.sessionSubject.value;

    if (!session) {
      this.clearSession();
      return null;
    }

    return session.tokenAccess;
  }

  private loadFromStorage(): LoginSession|null {
    const raw = sessionStorage.getItem(STORAGE_KEY);
    
    if (!raw) return null;

    try {
      const session = JSON.parse(raw) as LoginSession;
      
      return session;
    } catch {
      this.clearSession();
      return null;
    }
  }

  private saveSession(session: LoginSession) {
    sessionStorage.setItem(
      STORAGE_KEY,
      JSON.stringify(session)
    );

    this.sessionSubject.next(session);
  }

  private toSession(data: LoginApiReponse): LoginSession {
    return {
      user_id: data.user_id,
      email: '',
      expiresInMinutes: data.expires_in_minutes,
      tokenAccess: data.access_token,
      loggedAt: new Date().toISOString()
    };
  }
}
