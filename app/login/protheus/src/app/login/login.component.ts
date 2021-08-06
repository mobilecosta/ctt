import { HttpErrorResponse } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Validators } from '@angular/forms';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  loginForm: any;
  navigateTo: any;
  fb: any;

  constructor(


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

    login(): void {
  //    const formUser = this.loginForm?.getRawValue() as FormUser;

    //  this.service
      //  .login(formUser.cpf)
        subscribe(
          () => this.loginForm?.reset(),
          (error: HttpErrorResponse) => {
          },
//          () => this.router.navigate([this.navigateTo])
        );
        }





      }



function subscribe(arg0: () => any, arg1: (error: HttpErrorResponse) => void) {
  throw new Error('Function not implemented.');
}

