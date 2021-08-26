import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { PoStorageService } from '@po-ui/ng-storage';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { PoTableColumn } from '@po-ui/ng-components';
import { PoCheckboxGroupOption, PoMultiselectOption } from '@po-ui/ng-components';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent {

  title = 'Portal Pesquisa Satisfação (CTT)';

  hiringProcesses: Array<object>;
  hiringProcessesColumns: Array<PoTableColumn>;
  hiringProcessesFiltered: Array<object>;
  labelFilter: string = '';
  status: Array<string> = [];
  statusOptions: Array<PoCheckboxGroupOption>;


  getItems = [
      {
        hireStatus: 'hired',
        datas: '00/00/0000 até 00/00/0000',
        curso: 'João Victor',
        turma: '0001',
        sala: '0002',
        professores: 'Operador'
      }
    ];
   getColumns: Array<PoTableColumn> = [
     {
       property: 'hireStatus',
       label: 'Seleção',
       type: 'subtitle',
       subtitles: [
         { value: 'hired', color: 'success', label: 'Respondido', content: '1' },
         { value: 'progress', color: 'warning', label: 'Respondendo', content: '2' },
         { value: 'canceled', color: 'danger', label: 'Cancelado', content: '3' }
       ]
     },
     { property: 'datas', label: 'Datas', type: 'string' },
     { property: 'curso', label: 'Curso' },
     { property: 'turma', label: 'Turma' },
     { property: 'sala', label: 'Sala' },
     { property: 'professores', label: 'Professors', type: 'string' }
   ];

   getHireStatus = [
     { value: 'hired', label: 'Hired' },
     { value: 'progress', label: 'Progress' },
     { value: 'canceled', label: 'Canceled' }
   ];


  constructor(private router: Router, private storage: PoStorageService, private httpClient: HttpClient) {

    // this.httpClient.get('http://localhost:8080/api/v1/alunos') .subscribe (
    //   (datajson)=>{
    //  var curso = datajson.aCursos         //Variavel criado a partir do Json.
    //   datajson.aCursos.forEach((value,index) => {            //Foreach para percorrer o caminho do Json a cursos.
    //     this.getItems.push({
    //           hireStatus: 'hired',
    //           datas: `${value['PDF_DTINI']}  até ${value['PDF_DTFIM']}`,
    //           curso: value['PD3_NOME'],
    //           turma: value['PD7_TURMA'],
    //           sala: value['PD3_SALA'],
    //           professores: value['PD2_NOME']
    //         })
    //     });
    //   }
    // )
    // fim do httpclient
   }

  ngOnInit(): void {
    this.statusOptions = this.getHireStatus;
    this.hiringProcesses = this.getItems;
   this.hiringProcessesColumns = this.getColumns;

   this.hiringProcessesFiltered = [...this.hiringProcesses];

  }


  logout(): void {
  };

}
