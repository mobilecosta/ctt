import { ActivatedRouteSnapshot, CanActivate, CanActivateChild, Router, RouterStateSnapshot } from '@angular/router';
import { Injectable } from '@angular/core';

import { LoginService } from '../login/login.service';
import { Observable } from 'rxjs/internal/Observable';

@Injectable()
export class AuthGuardService implements CanActivate, CanActivateChild {

  constructor(private loginService: LoginService, private router: Router) {
  }

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<boolean> | boolean {
    return new Observable<boolean>((observer) => {
      this.checkLogin()
        .then((data) => {
          // autenticado
          observer.next(true);
          observer.complete();
        })
        .catch((error) => {    
          // nao autenticado      
          this.router.navigateByUrl('/login');
          observer.next(false);
          observer.complete();            
        });
    });
  }

  canActivateChild(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    return this.checkLogin();
  }

  checkLogin() {
    return this.loginService.isLoggedIn().then(isLoggedIn => !isLoggedIn ? this.router.createUrlTree(['/login']) : true);
  }
}
