import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpErrorResponse } from '@angular/common/http';
import { Router } from '@angular/router';
import { Observable, throwError } from 'rxjs';
@Injectable({
  providedIn: 'root'
})

export class AuthService {
  headers = new HttpHeaders().set('Content-Type', 'application/json');

  constructor(
    private http: HttpClient,
    public router: Router
  ) {
  }

  getToken() {
    let authToken = localStorage.getItem('access_token');
    if (authToken == ' ') { localStorage.getItem('TLToken'); };
    return authToken;
  }
  
  get clearToken(): boolean {
    localStorage.setItem('access_token', ' ');
    return true;
  }

  get isLoggedIn(): boolean {
    let authToken = localStorage.getItem('access_token');
    if (authToken == ' ') { authToken = localStorage.getItem('TLToken'); };
    if (authToken == ' ') { authToken = null};
    return (authToken !== null) ? true : false;
  }

  doLogout() {
    let removeToken = localStorage.removeItem('access_token');
    if (removeToken == null) {
      this.router.navigate(['log-in']);
    }
  }

  // Error 
  handleError(error: HttpErrorResponse) {
    let msg = '';
    if (error.error instanceof ErrorEvent) {
      // client-side error
      msg = error.error.message;
    } else {
      // server-side error
      msg = `Error Code: ${error.status}\nMessage: ${error.message}`;
    }
    return throwError(msg);
  }
}