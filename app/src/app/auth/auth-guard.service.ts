import { ActivatedRouteSnapshot, CanActivate, CanActivateChild, Router, RouterStateSnapshot } from '@angular/router';
import { Injectable } from '@angular/core';

import { LoginService } from '../login/login.service';
import { Observable } from 'rxjs/internal/Observable';

@Injectable()
export class AuthGuardService implements CanActivate, CanActivateChild {

  constructor(private loginService: LoginService, private router: Router) {
  }

  canActivate(
    ): Observable<boolean> | Promise<boolean> | boolean {
      if (this.loginService.isLoggedIn()) {
        return true;
      }
      this.router.navigate(['login']);
      return false;
    }
  
  canActivateChild(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    return this.checkLogin();
  }

  checkLogin() {
    return this.loginService.isLoggedIn().then(isLoggedIn => !isLoggedIn ? this.router.createUrlTree(['/login']) : true);
  }
}
