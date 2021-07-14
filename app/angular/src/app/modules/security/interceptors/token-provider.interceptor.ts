import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor,
} from '@angular/common/http';
import { Observable } from 'rxjs';

import { LoginService } from '@app/security/login/login.service';

@Injectable()
export class TokenProviderInterceptor implements HttpInterceptor {

  constructor(private loginService: LoginService) {}

  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    const accessToken = this.loginService.getToken();
    if (accessToken) {
      const authReq = request.clone({
        setHeaders: { authorization: `Bearer ${accessToken}` },
      });
      return next.handle(authReq);
    }

    return next.handle(request);
  }
}
