import { AccessToken } from './access-token';
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { HttpErrorResponse, HttpResponse } from '@angular/common/http';
import { PoNotificationService } from '@po-ui/ng-components';

import { LoginService } from './login.service';
import { FormUser } from './form-user';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent implements OnInit {
  loginForm?: FormGroup;
  navigateTo?: string;

  constructor(
    private fb: FormBuilder,
    private service: LoginService,
    private router: Router,
    private activatedRoute: ActivatedRoute,
    private notify: PoNotificationService
  ) {}

  ngOnInit(): void {
    this.loginForm = this.fb.group({
      cnpjcpf: [
        '',
        [
          Validators.required,
          Validators.pattern('^[0-9]{11,14}$'),
          Validators.maxLength(14),
        ],
      ],
      email: ['', [Validators.email, Validators.required]],
      pass: ['', [Validators.required, Validators.minLength(3)]],
    });

    this.navigateTo = this.activatedRoute.snapshot.params['to'] || '/';
  }
  login(): void {
    const formUser = this.loginForm?.getRawValue() as FormUser;

    this.service
      .login(formUser.cnpjcpf, formUser.email, formUser.pass)
      .subscribe(
        () => this.loginForm?.reset(),
        (error: HttpErrorResponse) => {
          this.notify.error({
            duration: 2000,
            message: 'Dados Inválidos',
            actionLabel: 'X',
          });
        },
        () => this.router.navigate([this.navigateTo])
      );
  }
}
