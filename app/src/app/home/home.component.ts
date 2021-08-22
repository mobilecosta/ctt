import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { PoStorageService } from '@po-ui/ng-storage';
import { HttpClient, HttpHeaders } from '@angular/common/http';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent {

  title = 'Portal Pesquisa Satisfação (CTT)';

  constructor(private router: Router, private storage: PoStorageService, private httpClient: HttpClient) {

    this.httpClient.get('http://172.24.50.16:8044/CTT/api/login/26277712802') .subscribe (
      (datajson)=>{

        console.log(datajson.aCursos);
        this.data.push({
          datas: '1980-01-01 até 1980-01-01',
          curso: 'Teste',
          turma: '01',
          sala:'C',
          professor: 'Mobile'
        });

        console.log(this.data);
      },
      (error)=>{

        console.log(error);


      }
      )

   }

  ngOnInit(): void {

  }

  rowActions = {

  };

  columns = [
    { property: 'datas', label: 'Datas', width:'50px',required:true},
    { property: 'curso', label: 'Curso', align:'center', width: '100px' },
    { property: 'turma', label: 'Turma', width: 80 },
    { property: 'sala', label: 'Sala', width: 100,  },
    { property: 'professor', label: 'Professor', width: 100, required: true }
  ];

  data = [
    {
      datas: '2021-08-04 até 2021-08-04',
      curso: 'Configurador',
      turma: '01',
      sala:'A',
      professor: 'João'
    },
    {
      datas: '2021-08-08 até 2021-08-08',
      curso: 'Módulo Financeiro',
      turma: '01',
      sala:'A',
      professor: 'Fernanda'
    },
    {
      datas: '2021-08-10 até 2021-08-10',
      curso: 'Configurador',
      turma: '02',
      sala:'A',
      professor: 'João'

    },
    {
      datas: '2021-08-11 até 2021-08-11',
      curso: 'Configurador',
      turma: '03',
      sala:'A',
      professor: 'João'
    },
    {
      datas: '2021-08-04 até 2021-08-04',
      curso: 'Advpl Básico',
      turma: '02',
      sala:'B',
      professor: 'Mário'
    },
    {
      datas: '2021-08-05 até 2021-08-06',
      curso: 'Módulo Faturamento',
      turma: '01',
      sala:'D',
      professor: 'Jéssica'
    },
    {
      datas: '2021-08-05 até 2021-08-08',
      curso: 'Advpl Avançado',
      turma: '01',
      sala:'D',
      professor: 'José'
    }
      ];

  onBeforeSave(row: any, _old: any) {
    return row.occupation !== 'Engineer';
  }

  logout(): void {
  };

}
