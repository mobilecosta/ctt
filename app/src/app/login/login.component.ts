import { Component } from '@angular/core';
import { Router } from '@angular/router';

import { PoNotificationService } from '@po-ui/ng-components';
import { PoPageLogin } from '@po-ui/ng-templates';
import { PoStorageService } from '@po-ui/ng-storage';

import { LoginService } from './login.service';

import { HttpClient, HttpHeaders } from '@angular/common/http';
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

    ) {}

    ngOnInit(): void {
      this.loginForm = this.formBuilder.group({
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



  loginSubmit() {

    var body: any;
    var resultado: any;
    const cpf = this.loginForm.controls['cpf'].value;
    var url_token = environment.urltoken;
    var url_login = environment.api + "api/login/" + cpf;

    // Autenticação Metodo retorno TOKEN
    this.httpClient.post(url_token, body).subscribe((res) => {
      if( 1 ==  1){
         this.storage.set('user', res).then(()=>{
          localStorage.setItem('access_token', res["access_token"])

          // Autenticação Metodo LOGIN baseado no CPF
          this.httpClient.get(url_login).subscribe((res) => {
            if( 1 ==  1){
              this.storage.set('user', res).then(()=>{
                this.router.navigate(['/']);
              })
            }else{
              this.poNotification.error('error usuário nao vindo do banco de dados')
            }
      
          }, (error) =>{
            if(! error.hasOwnProperty('user')){
              console.log(error)
      
            }
      
          })
 
        })
       }else{
         this.poNotification.error('Falha na autenticação')
       }
 
     }, (error) =>{
       if(! error.hasOwnProperty('user')){
         console.log(error)
 
       }
 
     })
 
  }

}
