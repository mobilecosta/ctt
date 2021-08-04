import { Component, OnInit,ViewChild } from '@angular/core';
import { NgForm } from '@angular/forms';

import { PoComboOption, PoComboOptionGroup, PoNotificationService, PoSelectOption } from '@po-ui/ng-components';
import { Subscription } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';

@Component({
  selector: 'app-list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.scss'],
  preserveWhitespaces:true
})
export class ListComponent implements OnInit {

  private readonly API ='http://localhost:3000/curso';
  private chamada!: Subscription;
  private headers!: HttpHeaders;
  httpClient: any;


  constructor(httpClient: HttpClient){}

  ngOnInit(): void {
    this.chamada = this.httpClient.get(this.API, { headers: this.headers })
    .subscribe((response: any) => {
      alert('Retornei');
    });


  }
  rowActions = {

  };

  columns = [
    { property: 'datas', label: 'Datas', width:'50px',required:true},
    { property: 'curso', label: 'Curso', align:'center', width: '100px' },
    { property: 'turma', label: 'Turma', width: 80 },
    { property: 'sala', label: 'Sala', width: 100,  },
    { property: 'professor', label: 'Professor', width: 100, required: true },


  ];

  data = [
    {
      datas: '2021-08-04 até 2021-08-04',
      curso: 'Configurador',
      turma: '01',
      sala:'A',
      professor: 'João',

    },
    {
      datas: '2021-08-08 até 2021-08-08',
      curso: 'Módulo Financeiro',
      turma: '01',
      sala:'A',
      professor: 'Fernanda',

    },
    {
      datas: '2021-08-10 até 2021-08-10',
      curso: 'Configurador',
      turma: '02',
      sala:'A',
      professor: 'João',

    },
    {
      datas: '2021-08-11 até 2021-08-11',
      curso: 'Configurador',
      turma: '03',
      sala:'A',
      professor: 'João',

    },
    {
      datas: '2021-08-04 até 2021-08-04',
      curso: 'Advpl Básico',
      turma: '02',
      sala:'B',
      professor: 'Mário',

    },
    {
      datas: '2021-08-05 até 2021-08-06',
      curso: 'Módulo Faturamento',
      turma: '01',
      sala:'D',
      professor: 'Jéssica',

    },
    {
      datas: '2021-08-05 até 2021-08-08',
      curso: 'Advpl Avançado',
      turma: '01',
      sala:'D',
      professor: 'José',

    }
      ];

  onBeforeSave(row: any, _old: any) {
    return row.occupation !== 'Engineer';
  }


}

