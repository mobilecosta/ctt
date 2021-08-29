import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { PoStorageService } from '@po-ui/ng-storage';
import { HttpClient } from '@angular/common/http';
import { PoDynamicViewField, PoCheckboxGroupOption, PoTableColumn } from '@po-ui/ng-components';


@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent {

  title = 'Portal Pesquisa Satisfação (CTT)';
  fields: Array<PoDynamicViewField> = [
    { property: 'name', label: 'CPF/Nome' },
    { property: 'email', label: 'Email' },
    { property: 'business', label: 'Empresa' },
    { property: 'class', label: 'Turma/Periodo - Curso/Professor' }
  ]
  employee = { }

  hiringProcesses: Array<object>;
  hiringProcessesColumns: Array<PoTableColumn>;
  hiringProcessesFiltered: Array<object>;
  labelFilter: string = '';
  status: Array<string> = [];
  statusOptions: Array<PoCheckboxGroupOption>;


  getItems = [];
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
    console.log(this.getHireStatus)
    this.storage.get('user').then((res) => {
      this.employee = {
        name: `${res.PDL_CPF} / ${res.PDL_NOME}`,
        email: res.PDL_EMAIL,
        business: `${res.A1_CGC} - ${res.A1_NOME} / Orçamento cod.`,
        class: `${res.PDL_NOME}`
      }

      res.aCursos.forEach((value, index) => {            //Foreach para percorrer o caminho do Json a cursos.
        this.getItems.push({
          hireStatus: 'progress',
          datas: `${value['PDF_DTINI']}  até ${value['PDF_DTFIM']}`,
          curso: value['PD3_NOME'],
          turma: value['PD7_TURMA'],
          sala: value['PD3_SALA'],
          professores: value['PD2_NOME']
        })
      })
    })

  } // fim do construtor

  pesquisa() {

    this.getItems.forEach((value, index) => {
      if (value.$selected == true) {
        console.log(value.curso, index)
        this.router.navigate([`/${value.curso}`]);
      }
    })
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
