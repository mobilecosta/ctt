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
    private poNotification: PoNotificationService



    ) { }

    ngOnInit(): void {
      this.loginForm = this.fb.group({
        cpf: [
          '',
          [
            Validators.required,
            Validators.pattern('^[0-9]{11}$'),
            Validators.maxLength(11),
          ],
        ],
     })


     ;
    // this.navigateTo = this.activatedRoute.snapshot.params['to'] || '/';

    }



  loginSubmit(formData: PoPageLogin) {

    var url = environment.api +
              'api/oauth2/v1/token?grant_type=password&password=' + formData.password +
              '&username=' + formData.login;
    var body: any;

/*
    Chamada PostLogin
    this.httpClient.post(url, body).subscribe((res) => {
      this.storage.set('isLoggedIn', 'true').then(() => {
        localStorage.setItem('access_token', res["access_token"])
        this.router.navigate(['/']);
      });
    }, (res) => {
      if ((! res.hasOwnProperty('access_token')))
        { this.poNotification.error('Usuário ou senha invalidos ! Tente novamente.') };
    });
*/
    this.router.navigate(['/']);

  }

}
