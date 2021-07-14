import { Injectable } from '@angular/core';
import {
  CanActivate,
  CanLoad,
  Route,
  UrlSegment,
  ActivatedRouteSnapshot,
  RouterStateSnapshot,
} from '@angular/router';

import { LoginService } from '@app/security/login/login.service';

@Injectable({
  providedIn: 'root',
})
export class AuthenticatedGuard implements CanActivate, CanLoad {
  constructor(private service: LoginService) {}

  canActivate(
    next: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): boolean {
    if (
      next.routeConfig !== undefined &&
      next.routeConfig?.path !== undefined
    ) {
      return this.checkAutenticated(next.routeConfig.path);
    }
    return false;
  }

  canLoad(route: Route, segments: UrlSegment[]): boolean {
    if (route.path !== undefined) {
      return this.checkAutenticated(route.path);
    }
    return false;
  }

  checkAutenticated(path: string): boolean {
    const logged = this.service.isLoggedIn();
    if (!logged) {
      this.service.handleLoggin();
    }

    return logged;
  }
}
