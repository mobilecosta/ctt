import { ActivatedRouteSnapshot, CanActivate, CanActivateChild, Router, RouterStateSnapshot } from '@angular/router';
import { Injectable } from '@angular/core';

import { LoginService } from '../login/login.service';
import { Observable } from 'rxjs/internal/Observable';
import { AuthService } from "./../auth/auth.service";
import { iif } from 'rxjs';

@Injectable()
export class AuthGuardService implements CanActivate, CanActivateChild {

  constructor(private loginService: LoginService, private router: Router, 
              private authService: AuthService) {
  }

  private isAuthenticated: boolean = false;

  canActivate(
    ): Observable<boolean> | Promise<boolean> | boolean {
      if (! this.isAuthenticated)
        { 
          this.authService.clearToken;
         };

      if (this.loginService.inlogin)
         { return true };

      if (this.authService.isLoggedIn) {
        this.isAuthenticated = true;
        return true;
      }

      this.loginService.inlogin = true;
      this.isAuthenticated = false;
      this.router.navigate(['login']);
      return false;
    }
  
  canActivateChild(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    return true;
  }

  checkLogin() {
  }
}
