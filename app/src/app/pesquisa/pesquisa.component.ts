import { Component, OnInit } from '@angular/core';
import { PoDynamicFormField, PoDynamicFormLoad } from '@po-ui/ng-components';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';
import { ActivatedRoute } from '@angular/router';
import { PoNotificationService } from '@po-ui/ng-components';
import { environment } from 'src/environments/environment';
import { PoStorageService } from '@po-ui/ng-storage';
import { NgForm, NgModelGroup } from '@angular/forms';
import { PoDynamicViewField, PoListViewLiterals } from '@po-ui/ng-components';

@Component({
  selector: 'app-pesquisa',
  templateUrl: './pesquisa.component.html',
  styleUrls: ['./pesquisa.component.scss']
})


export class PesquisaComponent implements OnInit {
  isHideLoading = false;
  title = 'Pesquisas'
  dynamicForm: NgForm;
  respostas = [];
  url_post = environment.api + 'api/grava';
  fields: Array<PoDynamicFormField>;
  filedstemp = []
  count: number = 0;
  aluno: string;
  filial: string;
  turma: string;
  periodo: string;
  curso: string;
  professor: string;
  pesquisa: string;
  inicio: string;
  datas: string;
  PD5_FINALI: string;
  PD5_FINALI_D = []
  pd5Table = []
  opt = []

  headerFields: Array<PoDynamicViewField> = [
    {property: 'name', label: 'CPF/Nome'},
    {property: 'email', label: 'Email'},
    {property: 'business', label: 'Empresa'},
    {property: 'class', label: 'Turma/Periodo - Curso/Professor'}
  ]

  employee = {}

  constructor(private storage: PoStorageService,
              private httpClient: HttpClient,
              private router: Router,
              private notify: PoNotificationService) {

      this.storage.get('pergunta').then((data) =>
      {
        this.aluno = data.aluno;
        this.filial = data.filial;
        this.turma = data.turma;
        this.periodo = data.periodo;
        this.curso = data.curso;
        this.professor = data.nome_professor;
        this.pesquisa = data.pesquisa;
        this.inicio = data.inicio;
        this.datas = data.datas;

        this.storage.get('user').then((res)=>{
          this.employee = {
            name: `${res.PDL_CPF} / ${res.PDL_NOME}`,
            email: res.PDL_EMAIL,
            business: `${res.A1_CGC} - ${res.A1_NOME}`,
            class: `${this.turma} / ${this.periodo} - ${this.curso} / ${this.professor} - ${this.datas}`
          }
        })
  
        this.updPesquisa();
      }
        );

  }

  updPesquisa() {
    let url = environment.api + 'api/montagem?filial=' + this.filial + '&turma=' + this.turma + '&periodo=' + this.periodo;
    this.PD5_FINALI = ' ';
    this.httpClient.get(url).subscribe((res)=>{
        var [pesquisa] = [res['aPesq']]

        pesquisa.forEach(element => {
          this.opt.push(element['PD5_ASSUNTO'])

          this.pd5Table.push({
            "PD5_ITEM": element['PD5_ITEM'],
            "PD5_FINALI": element['PD5_FINALI'],
            "PD5_DEPTO":  element['PD5_DEPTO'],
            "PD5_ASSUNT": element['PD5_ASSUNTO'],
            "PD5_PONTUA": element['PD5_PONTUA'],
          })

            if (! (this.PD5_FINALI == element['PD5_FINALI'])) { this.count = 1 };

            this.PD5_FINALI = element['PD5_FINALI'];
            var divider = this.count == 1 ? '0' + element['PD5_FINALI'] + ' ' + element['PD5_FINALI_D']: ' ';

            if(element['PD5_ASSUNTO'] == '2'){
              this.filedstemp.push({
                property: element['PD5_ITEM'],
                label: element['PD5_FINALI'] + '.0' + `${this.count}: `+`${element['PD5_PERGUN']}`,
                divider: divider,
                gridColumns: 10,
                gridSmColumns: 15,
                rows: 5,
                key: element['PD5_ITEM'],
                placeholder: 'coloque seu texto'
              })

            }else{
              this.filedstemp.push({
              property: element['PD5_ITEM'],
              label: element['PD5_FINALI'] + '.0' + `${this.count}: `+`${element['PD5_PERGUN']}`,
              divider: divider,
              gridColumns: 10,
              gridSmColumns: 15,
              required: true,
              minLength: 1,
              fieldValue: ' ',
              key: element['PD5_ITEM'],
              options: element['aRespostas']
            })
            }
            this.count+=1;
          });
          this.fields = this.filedstemp;
          this.isHideLoading = true;
        }, (err)=>{
        console.log(err)
      })

    }

  getForm(form: NgForm) {
    this.dynamicForm = form;
  }

  ngOnInit() {};

  onClick() {

    var result = true;

    this.pd5Table.forEach((element) => {

      this.respostas.push({
        "PD4_ITEM":   element['PD5_ITEM'],
        "PD4_FINALI": element['PD5_FINALI'],
        "PD4_DEPTO":  element['PD5_DEPTO'],
        "PD4_ASSUNT": element['PD5_ASSUNT'],
        "PD4_PONTUA": element['PD5_PONTUA'],
        "PD4_RESPOS":  element['PD5_ASSUNT'] == '2' ?  this.dynamicForm.controls[element['PD5_ITEM']].value: ' ',
        "PD4_EQUIV": element['PD5_ASSUNT'] == '1' ?  this.dynamicForm.controls[element['PD5_ITEM']].value: ' '
      })
      if ((element['PD5_ASSUNT'] == '1') && (this.dynamicForm.controls[element['PD5_ITEM']].value == null))
        result = false;

    });

     if(result){
          this.httpClient.post(this.url_post, {
            "PD4_ALUNO": this.aluno,
            "PD4_FILIAL": this.filial,
            "PD4_TURMA": this.turma,
            "PD4_PERIO": this.periodo,
            "PD4_PROF": this.professor,
            "PD4_PESQ": this.pesquisa,
            "PD4_DTCURS": this.inicio,
            "respostas": this.respostas
          }).subscribe((success)=> {
            this.router.navigate([`/sucess`]);
          }, (error)=>{
            window.alert('Erro na gravação das perguntas ' + error["msg"]);
          })
      }else{
        this.notify.error("Todos os campos devem ser preenchidos!")
      }
  }

}