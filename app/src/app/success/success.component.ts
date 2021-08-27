import { Component, OnInit } from '@angular/core';
import { PoDynamicViewField, PoListViewLiterals } from '@po-ui/ng-components';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from 'src/environments/environment';

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
  employee = {
    name: 'xxx.xxx.xxx-xx / Nome',
    email: 'email@email.com',
    business: 'xxx.xxx.xxx/xxx-xx - Business / Oraçamento cod.',
    class: 'class/turn - course/teacher'
  }
  constructor(private httpClient: HttpClient) {

    // employee = {}
    //  var url = environment.aluno;
    // this.httpClient.get(url) .subscribe (
    //   (datajson)=>{
    //  var curso = datajson.alunos         //Variavel criado a partir do Json.
    //   datajson.aCursos.forEach((value,index) => {            //Foreach para percorrer o caminho do Json a cursos.
    //this.employee = { name: value; email: string; business: string; class: string; }
    //     });
    //   }
    // )

  }

  ngOnInit() {
  }

}
const fields = [
  {}
]

