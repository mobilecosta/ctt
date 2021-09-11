import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from '../login/login.component';
import { LoginService } from '../login/login.service';
import { HomeComponent } from './home.component';
import { AuthInterceptor } from '../auth/auth-config.interceptor';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { AuthGuardService } from '../auth/auth-guard.service';

const homeRoutes: Routes = [
  { path: '', component: HomeComponent,
    canActivate: [AuthGuardService],
    children: [  ] },
    {path:'', component: LoginComponent}

];

@NgModule({
  imports: [RouterModule.forChild(homeRoutes)],
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
export class HomeRoutingModule { }
