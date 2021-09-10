import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './login.component';
import { LoginService } from '../login/login.service';
import { AuthInterceptor } from '../auth/auth-config.interceptor';
import { HTTP_INTERCEPTORS } from '@angular/common/http';

const loginRoutes: Routes = [
  { path: '', component: LoginComponent ,
  children: [
  ]
}
];

@NgModule({
  imports: [RouterModule.forChild(loginRoutes)],
  exports: [RouterModule]
  //,providers: [
  //  LoginService,
  //  {
  //    provide: HTTP_INTERCEPTORS,
  //    useClass: AuthInterceptor,
  //    multi: true
  //  }
  //]
})
export class LoginRoutingModule { }
