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
    { property: 'business', label: 'Empresa' }
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
      property: 'status',
      label: 'Seleção',
      type: 'subtitle',
      color: 'subtitle',
      subtitles: [
        { value: 'hired', color: 'color-07', label: 'Respondido', content: '1' },
        { value: 'progress', color: 'color-10', label: 'A Responder', content: '2' }
      ]
    },
    { property: 'datas', label: 'Datas', type: 'string' },
    { property: 'curso', label: 'Curso' },
    { property: 'filial', label: 'Filial' },
    { property: 'turma', label: 'Turma' },
    { property: 'periodo', label: 'Periodo' },
    { property: 'sala', label: 'Sala' },
    { property: 'cod_professor', label: 'Cod Professor', type: 'string', visible: false },
    { property: 'professor', label: 'Nome Professor', type: 'string' },
    { property: 'pesquisa', label: 'Pesquisa', type: 'string', visible: false },
    { property: 'inicio', label: 'Dt Inicio', type: 'string', visible: false }
  ];

  getHireStatus = [
    { value: 'hired', label: 'Respondido' },
    { value: 'progress', label: 'Respondendo' }
  ];


  constructor(private router: Router, private storage: PoStorageService, private httpClient: HttpClient) {

    this.storage.get('user').then((res) => {
      this.aluno = res.PDL_ALUNO;
      this.employee = {
        name: `${res.PDL_CPF} / ${res.PDL_NOME}`,
        email: res.PDL_EMAIL,
        business: `${res.A1_CGC} - ${res.A1_NOME}`
      }

      res.aCursos.forEach((value, index) => {            //Foreach para percorrer o caminho do Json a cursos.
        var fstatus = 'progress';
        if (value['PD7_PESQOK'] == 1) { fstatus = 'hired' };
        this.getItems.push({
          status: fstatus,
          datas: `${value['PDF_DTINI']} até ${value['PDF_DTFIM']}`,
          curso: value['PD3_NOME'],
          filial: value['PD3_FILIAL'],
          turma: value['PD3_TURMA'],
          periodo: value['PDF_PERIO'],
          sala: value['PD3_SALA'],
          cod_professor: value['PD3_PROF'],
          professor: value['PD2_NOME'],
          pesquisa: value['PD3_PESQ'],
          inicio: value['PDF_DTINI']
        })


      })
    })




}
   // fim do construtor

  pesquisa() {

    this.getItems.forEach((value, index) => {
      if ((value.$selected == true) && (value.status == 'hired')) {
        window.alert('Pesquisa já respondida');
      }
      else if (value.$selected == true) {
        this.storage.set('pergunta',
          { "aluno": this.aluno,
            "filial": value.filial,
            "turma": value.turma,
            "periodo": value.periodo,
            "curso": value.curso,
            "professor": value.cod_professor,
            "nome_professor": value.professor,
            "pesquisa": value.pesquisa,
            "inicio": value.inicio,
            "datas": value.datas }).then((res) => {
      })
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

