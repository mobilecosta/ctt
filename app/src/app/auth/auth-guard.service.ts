import { ActivatedRouteSnapshot, CanActivate, CanActivateChild, Router, RouterStateSnapshot } from '@angular/router';
import { Injectable } from '@angular/core';

import { LoginService } from '../login/login.service';
import { Observable } from 'rxjs/internal/Observable';
import { AuthService } from "./../auth/auth.service";

@Injectable()
export class AuthGuardService implements CanActivate, CanActivateChild {

  constructor(private loginService: LoginService, private router: Router, 
              private authService: AuthService) {
  }

  canActivate(
    ): Observable<boolean> | Promise<boolean> | boolean {
      if (this.authService.isLoggedIn) {
        return true;
      }
      if (this.loginService.inlogin) {
        return true;
      }

      this.loginService.inlogin = true;
      this.router.navigate(['login']);
      return false;
    }
  
  canActivateChild(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    return true;
  }

  checkLogin() {
  }
}
