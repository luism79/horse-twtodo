import { Routes } from '@angular/router';
import { authGuard } from './core/guards/auth-guard';

export const routes: Routes = [
  {
    path: 'login',
    loadComponent: () => 
      import('./features/auth/login').then(m => m.Login)
  },
  {
    path: '',
    canActivate: [authGuard],
    loadComponent: () =>
      import('./layouts/main-layout').then(m => m.MainLayout),
    children: [
      {
        path: 'dashboard',
        loadComponent: () =>
            import('./features/dashboard/dashboard').then(m => m.Dashboard)
      },
      {
        path: 'tasks',
        loadComponent: () =>
          import('./features/tasks/tasks').then(m => m.Tasks)
      }
    ]
  }
];
