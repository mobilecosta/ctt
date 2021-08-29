import { Component } from '@angular/core';
import { Router } from '@angular/router';

import { PoNotificationService } from '@po-ui/ng-components';
import { PoPageLogin } from '@po-ui/ng-templates';
import { PoStorageService } from '@po-ui/ng-storage';

import { LoginService } from './login.service';

import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment'
import { FormGroup, FormBuilder, Validators } from '@angular/forms'

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {

  hideRememberUser: boolean = true;
  loginForm: FormGroup;
  formData: PoPageLogin

  constructor(
    private loginService: LoginService,
    private router: Router,
    private httpClient: HttpClient,
    private storage: PoStorageService,
    private poNotification: PoNotificationService,
    private formBuilder: FormBuilder

<<<<<<< HEAD
    ) {
      this.storage.remove('user').then((res)=>{
        console.log('usuario removido')
      })
    }

    ngOnInit(): void {
      this.loginForm = this.formBuilder.group({
        cpf: [
          '',
          [
            Validators.required,
            Validators.pattern('^[0-9]{11}$'),
            Validators.maxLength(11),
          ],
=======
  ) {
    this.storage.remove('user').then((res) => {
      console.log('usuario removido')
    })
  }

  ngOnInit(): void {
    this.form = this.formBuilder.group({
      cpf: [
        '',
        [
          Validators.required,
          Validators.pattern('^[0-9]{11}$'),
          Validators.maxLength(11),
>>>>>>> a5fbb801bae9cee922f1d235839a06ce545895f0
        ],
      ],
    })


      ;
    // this.navigateTo = this.activatedRoute.snapshot.params['to'] || '/';

  }



  loginSubmit() {

    // var url_token = environment.api +
    //           'api/oauth2/v1/token?grant_type=password&password=' + this.formData.password +
    //           '&username=' + this.formData.login;
    var body: any;
    var resultado: any;
    const cpf = this.loginForm.controls['cpf'].value
    var url_login = environment.api + "api/login/" + cpf

    this.httpClient.get(url_login).subscribe((res) => {
<<<<<<< HEAD
     if( 1 ==  1){
        this.storage.set('user', res).then(()=>{
=======
      if (res['resultado']) {
        this.storage.set('user', res).then(() => {
>>>>>>> a5fbb801bae9cee922f1d235839a06ce545895f0
          this.poNotification.success('Usuário encontrado banco de dados')
          this.router.navigate(['/']);
        })
      } else {
        this.poNotification.error('error usuário nao vindo do banco de dados')
      }

    }, (error) => {
      if (!error.hasOwnProperty('user')) {
        console.log(error)

      }

    })

<<<<<<< HEAD
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
=======
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
>>>>>>> a5fbb801bae9cee922f1d235839a06ce545895f0
    //this.router.navigate(['/']);

  }

}
