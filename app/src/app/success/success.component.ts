import { Component, OnInit } from '@angular/core';
import { PoDynamicViewField, PoListViewLiterals } from '@po-ui/ng-components';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { PoStorageService } from '@po-ui/ng-storage';

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
  constructor(private storage: PoStorageService) {

    this.storage.get('user').then((res)=>{
       console.log(res)
       this.employee = {
         name: `${res.PDL_CPF} / ${res.PDL_NOME}`,
         email: res.PDL_EMAIL,
         business: `${res.A1_CGC} - ${res.A1_NOME}`,
         class: `${res.PDL_NOME}`
       }
     })

  }

  ngOnInit() {
  }

}
const fields = [
  {}
]

