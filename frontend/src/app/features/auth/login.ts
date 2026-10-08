import {
  AfterViewInit,
  Component,
  ElementRef,
  inject, 
  signal, 
  ViewChild
} from '@angular/core';
import {
  NonNullableFormBuilder,
  ReactiveFormsModule,
  Validators
} from '@angular/forms';
import { Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { AuthService } from '../../core/services/auth.service';
import { finalize } from 'rxjs';
import { MatSnackBar } from '@angular/material/snack-bar';
import { HttpErrorResponse } from '@angular/common/http';
import { getHttpErrorMessage } from '../../core/interceptors/http-error.interceptor';

const PW_MIN_LENGTH = 3;

@Component({
  imports: [
    ReactiveFormsModule,
    MatButtonModule,
    MatCardModule,
    MatFormFieldModule,
    MatIconModule,
    MatInputModule,
    MatProgressSpinnerModule
  ],
  selector: 'app-login',
  styleUrl: './login.scss',
  templateUrl: './login.html',
})
export class Login implements AfterViewInit {
  @ViewChild('email') emailInput!: ElementRef<HTMLInputElement>;
  protected readonly fb = inject(NonNullableFormBuilder);
  protected readonly router = inject(Router);
  protected readonly auth = inject(AuthService);
  protected readonly snackBar = inject(MatSnackBar);
  protected minLength = PW_MIN_LENGTH;
  protected loading = signal(false);
  protected hidePassword = true;
  protected readonly form = this.fb.group({
    email: ['', [Validators.required, Validators.email]],
    password: ['', [Validators.required, Validators.minLength(PW_MIN_LENGTH)]]
  });

  ngAfterViewInit(): void {
    this.emailInput.nativeElement.focus();
  }

  submit() {
    if (this.loading()) return;

    this.setLoading(true);
    const value = this.form.getRawValue();

    this.auth.login(value)
      .subscribe({
        next: () => this.router.navigate(['/dashboard']),
        error: (error: HttpErrorResponse) => {
          this.setLoading(false);
          this.snackBar.open(
            getHttpErrorMessage(error),
            'Fechar',
            { duration: 4500}
          );
          this.emailInput.nativeElement.select();
        } 
      });
  }

  private setLoading(value: boolean) {
    this.loading.set(value);
  }
}
