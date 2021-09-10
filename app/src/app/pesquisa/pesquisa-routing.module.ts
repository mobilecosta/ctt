import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginService } from '../login/login.service';
import { AuthInterceptor } from '../auth/auth-config.interceptor';
import { HTTP_INTERCEPTORS } from '@angular/common/http';

import { PesquisaComponent } from './pesquisa.component';

const pesquisaRoutes: Routes = [
  { path: '', component: PesquisaComponent,
    children: [
    ] }
];

@NgModule({
  imports: [RouterModule.forChild(pesquisaRoutes)],
  exports: [RouterModule],
  providers: [
    LoginService,
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      multi: true
    }
  ]
})
export class PesquisaRoutingModule { }
