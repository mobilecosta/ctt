import { AccessToken } from './access-token';
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { HttpErrorResponse, HttpHeaders, HttpResponse } from '@angular/common/http';
import { PoNotificationService } from '@po-ui/ng-components';

import { LoginService } from './login.service';
import { FormUser } from './form-user';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent implements OnInit {
  loginForm?: FormGroup;
  navigateTo?: string;
  httpClient: any;
   private url: 'http://localhost:3000/curso' | undefined;

  private chamada!: Subscription;
    private headers!: HttpHeaders;

  constructor(
    private fb: FormBuilder,
    private service: LoginService,
    private router: Router,
    private activatedRoute: ActivatedRoute,
    private notify: PoNotificationService,



  ) {}

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



    this.navigateTo = this.activatedRoute.snapshot.params['to'] || '/';
  }
  login(): void {
    const formUser = this.loginForm?.getRawValue() as FormUser;

    this.service
      .login(formUser.cpf)
      .subscribe(
        () => this.loginForm?.reset(),
        (error: HttpErrorResponse) => {

        },
        () => this.router.navigate([this.navigateTo])
      );
  }

  onClick(){
    this.headers = new HttpHeaders();

    this.chamada = this.httpClient.get(this.url + '10480616000160', { headers: this.headers })
      .subscribe((response: any) => {
        alert('CNPJ Cadastrado xx');
      });

   }




  }

