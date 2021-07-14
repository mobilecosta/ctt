import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { AuthenticatedGuard } from '@app/security/guards/authenticated.guard';
import { LoginComponent } from '@app/security/login/login.component';
import { HomeComponent } from './layout/home/home.component';
import { AccountComponent } from './layout/account/account.component';

const routes: Routes = [
  {
    path: '',
    component: HomeComponent,
    children: [
      { path: '', redirectTo: 'dash', pathMatch: 'full' },
      {
        path: 'dash',
        loadChildren: () =>
          import('@app/dash-board/dash-board.module').then(
            m => m.DashBoardModule
          ),
      },
      {
        path: 'reports',
        loadChildren: () =>
          import('@app/reports/reports.module').then(m => m.ReportsModule),
      },
    ],
    canActivate: [AuthenticatedGuard],
  },
  {
    path: '',
    component: AccountComponent,
    children: [
      { path: '', redirectTo: '/login', pathMatch: 'full' },
      { path: 'login', component: LoginComponent },
      { path: 'login/:to', component: LoginComponent },
    ],
  },
];
@NgModule({
  imports: [RouterModule.forRoot(routes, { useHash: false })],
  exports: [RouterModule],
})
export class AppRoutingModule {}
