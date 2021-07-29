import { Component } from '@angular/core';
import { Router } from '@angular/router';

import { PoNotificationService } from '@po-ui/ng-components';
import { PoPageLogin } from '@po-ui/ng-templates';
import { PoStorageService } from '@po-ui/ng-storage';

import { LoginService } from './login.service';

import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from 'src/environments/environment'
import { Validators } from '@angular/forms';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {

  hideRememberUser: boolean = true;
  loginForm: any;
  fb: any;

  constructor(
    private loginService: LoginService,
    private router: Router,
    private httpClient: HttpClient,
    private storage: PoStorageService,
    private poNotification: PoNotificationService) { }

  loginSubmit(formData: PoPageLogin) {

    // var url = environment.api + 'token';
    var url ='http://localhost:3000/login'
    var body: any;
    var header: HttpHeaders;

/*
    Chamada TOTVS

    header = new HttpHeaders().set('Authorization', 'Basic TVBrRVE1ZFJHZzFkSkxHcTlDM05mSFQxa21nYTpHSFBFamZwaXJYbEVvTjBmbWRndGhqaUk3ZWth');
    header.append('Content-Type', 'application/x-www-form-urlencoded')

    this.httpClient.post(url, body, { headers: header } ).subscribe((res) => {
      this.storage.set('isLoggedIn', 'true').then(() => {
        localStorage.setItem('access_token', res["access_token"])
        this.router.navigate(['/']);
      });
    }, (res) => {
      if ((! res.hasOwnProperty('access_token')))
        { this.poNotification.error('Usuário ou senha invalidos ! Tente novamente.') };
    });
*/

    var body: any;
    body = '{       "email":"luanpedro@gmail.com", "password":"silva" }'
    header = new HttpHeaders().set('Content-Type', 'application/json');

    this.httpClient.post(url, body, { headers: header } ).subscribe((res) => {
      this.storage.set('isLoggedIn', 'true').then(() => {
        this.router.navigate(['/']);
      });
    }, (res) => {
      if ((! res.hasOwnProperty('access_token')))
        { this.poNotification.error('Usuário ou senha invalidos ! Tente novamente.') };
    });


  }

}



