import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from '../login/login.component';
import { HomeComponent } from './home.component';
import { AuthGuardService } from '../auth/auth-guard.service';

const homeRoutes: Routes = [
  { path: '', component: HomeComponent,
    canActivate: [AuthGuardService],
    children: [  ] },
    {path:'', component: LoginComponent}

];

@NgModule({
  imports: [RouterModule.forChild(homeRoutes)],
  exports: [RouterModule]
})
export class HomeRoutingModule { }
