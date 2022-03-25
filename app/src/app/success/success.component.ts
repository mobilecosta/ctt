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
  turma: string;
  periodo: string;
  curso: string;
  nome_professor: string;
  datas: string;
  employee = {}
  cpf: string;

  fields: Array<PoDynamicViewField> = [
    {property: 'name', label: 'CPF/Nome'},
    {property: 'email', label: 'Email'},
    {property: 'business', label: 'Empresa'},
    {property: 'class', label: 'Turma/Periodo - Curso/Professor'}
  ]

  constructor(private router: Router, 
              private httpClient: HttpClient,
              private storage: PoStorageService) {

    this.storage.get('pergunta').then((res)=>{
      this.cpf = res.PDL_CPF;

      this.storage.get('pergunta').then((res)=>{
        this.turma = res.turma;
        this.periodo = res.periodo;
        this.curso = res.curso;
        this.nome_professor = res.nome_professor;
        this.datas = res.datas;

        this.employee = {
          name: `${res.PDL_CPF} / ${res.PDL_NOME}`,
          email: res.PDL_EMAIL,
          business: `${res.A1_CGC} - ${res.A1_NOME}`,
          class: `${this.turma} / ${this.periodo} - ${this.curso} / ${this.nome_professor} - ${this.datas}`
        }
      });

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

