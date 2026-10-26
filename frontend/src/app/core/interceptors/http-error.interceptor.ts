import { HttpErrorResponse, HttpInterceptorFn } from "@angular/common/http";
import { inject } from "@angular/core";
import { AuthService } from "../services/auth.service";
import { Router } from "@angular/router";
import { MatSnackBar } from "@angular/material/snack-bar";
import { catchError, throwError } from "rxjs";

export const httpErrorInterceptor: HttpInterceptorFn = (req, next) => {
  const auth = inject(AuthService);
  const router = inject(Router);
  const snackBar = inject(MatSnackBar);

  return next(req)
    .pipe(
      catchError((error: HttpErrorResponse) => {
        if (error.status === 401) {
          auth.clearSession();
          void router.navigate(['/login']);
          snackBar.open('Sua sessão expirou. Entre novamente.', 'Fechar', { duration: 4500 });
        }
        return throwError(() => error);
      })
    );
};

export function getHttpErrorMessage(error: HttpErrorResponse): string {
  const errorValue = error.error;
  return errorValue?.error ??
    errorValue?.message ??
    'Ocorreu um erro inesperado. Tente novamente.';
}