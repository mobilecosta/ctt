import { Component, OnInit } from '@angular/core';
import { PoDynamicViewField, PoListViewLiterals } from '@po-ui/ng-components';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { PoStorageService } from '@po-ui/ng-storage';
import { Router } from '@angular/router';

@Component({
  templateUrl: './success.component.html',
  styleUrls: ['./success.component.scss']
})


export class SuccessComponent implements OnInit {

  fields: Array<PoDynamicViewField> = [
    {property: 'name', label: 'CPF/Nome'},
    {property: 'email', label: 'Email'},
    {property: 'business', label: 'Empresa'},
    {property: 'class', label: 'Turma/Periodo - Curso/Professor'}
  ]

  employee = {}
  cpf: string;
  constructor(private router: Router, 
              private httpClient: HttpClient,
              private storage: PoStorageService) {

    this.storage.get('user').then((res)=>{
       this.employee = {
         name: `${res.PDL_CPF} / ${res.PDL_NOME}`,
         email: res.PDL_EMAIL,
         business: `${res.A1_CGC} - ${res.A1_NOME}`,
         class: `${res.PDL_NOME}`
       }
       this.cpf = res.PDL_CPF;
     })

  }

  ngOnInit() {
  }

  onClick() {
    var url_login = environment.api + "api/login/" + this.cpf;
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
         
  };

}

