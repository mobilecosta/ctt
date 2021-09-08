import { NgModule, Component } from '@angular/core';
import { PreloadAllModules, RouterModule, Routes } from '@angular/router';

import { AuthGuardService } from './auth/auth-guard.service';
import { SuccessComponent } from './success/success.component';

const routes: Routes = [

  {
    path: 'login',
    canActivate: [AuthGuardService],
    loadChildren: () => import('./login/login.module').then(m => m.LoginModule)
  },
  {
    path: 'home',
    canActivate: [AuthGuardService],
    loadChildren: () => import('./home/home.module').then(m => m.HomeModule),
  },

  {
    path: 'pesquisa',
    canActivate: [AuthGuardService],
    loadChildren: () => import('./pesquisa/pesquisa.module').then(m => m.PesquisaModule)
  },
  {
    path: 'success',
    canActivate: [AuthGuardService],
    component: SuccessComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes, { preloadingStrategy: PreloadAllModules })],
  exports: [RouterModule]
})
export class AppRoutingModule { }
