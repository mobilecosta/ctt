import { Injectable } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { HttpClient, HttpParams, HttpHeaders } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';
import { tap, take } from 'rxjs/operators';

import * as CryptoJS from 'crypto-js';

import { environment } from '@env/environment';
import { AccessToken } from './access-token';
import { LoginToken } from './login-token';

@Injectable({
  providedIn: 'root',
})
export class LoginService {
  private endpoint = `${environment.api}auth`;
  private lastUrl: string;
  private token?: LoginToken;

  constructor(private http: HttpClient, private router: Router) {
    this.lastUrl = btoa('/');
    this.router.events.subscribe(e => {
      if (e instanceof NavigationEnd) {
        this.lastUrl = btoa(e.url);
      }
    });
    this.loadCredentials();
  }

  public login(
    cnpjCpf: string,
    email: string,
    pass: string
  ): Observable<AccessToken> {
    const password: string = CryptoJS.MD5(pass).toString();
    return this.http
      .post<AccessToken>(
        `${this.endpoint}`,
        new HttpParams()
          .set('cnpjcpf', cnpjCpf)
          .set('email', email)
          .set('password', password)
          .toString(),
        {
          headers: new HttpHeaders().set(
            'Content-Type',
            'application/x-www-form-urlencoded'
          ),
        }
      )
      .pipe(
        tap(token => this.registerCredentials(token)),
        take(1)
      );
  }

  logout(): void {
    this.unRegisterCredentials();
  }

  isLoggedIn(): boolean {
    return this.loadCredentials();
  }

  getToken(): string | undefined {
    return this.token?.jwtToken;
  }

  handleLoggin(path: string = this.lastUrl): void {
    this.router.navigate(['/login', atob(path)]);
  }

  private registerCredentials(token: AccessToken): void {
    this.token = new LoginToken(token);
    localStorage.setItem('token', this.token.jwtToken);
  }

  private unRegisterCredentials(): void {
    this.token = undefined;
    localStorage.removeItem('token');
  }

  private loadCredentials(): boolean {
    if (this.token === undefined) {
      const token = localStorage.getItem('token');

      if (token) {
        this.token = new LoginToken({ authorization: token });
      }
    }

    const loaded: boolean = !!this.token && this.token.isValid;

    if (!loaded) {
      this.unRegisterCredentials();
    }

    return loaded;
  }

  get loginSubject(): Observable<LoginToken> | undefined {
    return this.token?.getLoginSubject();
  }
}
