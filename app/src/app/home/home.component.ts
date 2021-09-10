import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { PoStorageService } from '@po-ui/ng-storage';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { PoDynamicViewField, PoCheckboxGroupOption, PoTableColumn } from '@po-ui/ng-components';
import { environment } from 'src/environments/environment';

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

  aluno: string;
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
        { value: 'progress', color: 'warning', label: 'Respondendo', content: '2' }
      ]
    },
    { property: 'datas', label: 'Datas', type: 'string' },
    { property: 'curso', label: 'Curso' },
    { property: 'turma', label: 'Turma' },
    { property: 'periodo', label: 'Periodo' },
    { property: 'sala', label: 'Sala' },
    { property: 'cod_professor', label: 'Cod Professor', type: 'string', visible: false },
    { property: 'professor', label: 'Nome Professor', type: 'string' },
    { property: 'pesquisa', label: 'Pesquisa', type: 'string', visible: false },
    { property: 'inicio', label: 'Dt Inicio', type: 'string', visible: false }
  ];

  getHireStatus = [
    { value: 'hired', label: 'Hired' },
    { value: 'progress', label: 'Progress' }
  ];


  constructor(private router: Router, private storage: PoStorageService, private httpClient: HttpClient) {

    this.httpClient.get(environment.api)
    this.storage.get('user').then((res) => {
      this.aluno = res.PDL_ALUNO;
      this.employee = {
        name: `${res.PDL_CPF} / ${res.PDL_NOME}`,
        email: res.PDL_EMAIL,
        business: `${res.A1_CGC} - ${res.A1_NOME}`,
        class: `${res.PDL_NOME}`
      }

      res.aCursos.forEach((value, index) => {            //Foreach para percorrer o caminho do Json a cursos.
        var status = 'progress';
        if (value['PD7_PESQOK'] == 1) { status = 'hired' };
        this.getItems.push({
          hireStatus: status,
          datas: `${value['PDF_DTINI']} até ${value['PDF_DTFIM']}`,
          curso: value['PD3_NOME'],
          turma: value['PD7_TURMA'],
          periodo: value['PDF_PERIO'],
          sala: value['PD3_SALA'],
          cod_professor: value['PD3_PROF'],
          professor: value['PD2_NOME'],
          pesquisa: value['PD3_PESQ'],
          inicio: value['PDF_DTINI']
        })
      })
    })

  } // fim do construtor

  pesquisa() {

    this.getItems.forEach((value, index) => {
      if (value.$selected == true) {
        this.storage.set('pergunta',
          { "aluno": this.aluno,
            "turma": value.turma,
            "periodo": value.periodo,
            "professor": value.cod_professor,
            "pesquisa": value.pesquisa,
            "inicio": value.inicio }).then((res) => {
        this.storage.get('pergunta').then((res)=>{
          console.log(res)
        })
        })
        console.log(value.curso, index)

        this.router.navigate([`/pesquisa`]);
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
