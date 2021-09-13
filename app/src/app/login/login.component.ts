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
  private headers: HttpHeaders;
    
  constructor(
    private loginService: LoginService,
    private router: Router,
    private httpClient: HttpClient,
    private storage: PoStorageService,
    private poNotification: PoNotificationService,
    private formBuilder: FormBuilder

    ) {}

    ngOnInit(): void {
      localStorage.setItem('access_token', ' '); 
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

    }



  loginSubmit() {

    var body: string;
    const cpf = this.loginForm.controls['cpf'].value;
    var url_token = environment.urltoken;
    var url_login = environment.api + "api/login/" + cpf;

    if (environment.wso2) {
      this.headers = new HttpHeaders({
        'X-PO-No-Message': 'true',
        'Content-Type': 'application/x-www-form-urlencoded',
        Authorization: 'Basic UjJhbHJFZDRoQWh1MmZSMFRPQnVCTlpxdFM0YTpsUDBUYktKUDdmQ245WGJDUktkM2pYZDFYRW9hIA' });

      body = 'grant_type=client_credentials';
    };

    // Autenticação Metodo retorno TOKEN
    this.httpClient.post(url_token, body, { headers: this.headers }).subscribe((res) => {
      if( res.hasOwnProperty('access_token') ){
        this.storage.set('user', res).then(()=>{
          localStorage.setItem('access_token', res["access_token"])

          // Autenticação Metodo LOGIN baseado no CPF
          this.httpClient.get(url_login).subscribe((res) => {
            if( res["resultado"] ==  1){
              this.storage.set('user', res).then(()=>{
                this.router.navigate(['/']);
              })
            } else{
              localStorage.setItem('access_token', " ");
              window.alert(res["DESCRICAO"])
            }
      
          }, (error) =>{
            if(error.hasOwnProperty('message')){
              window.alert(error.message);
      
            }
      
          })
 
        })
       }else{
         this.poNotification.error('Falha na autenticação')
       }
 
     }, (error) =>{
       if(error.hasOwnProperty('message')){
        window.alert(error.message)
 
       }
 
     })
 
  }

}
