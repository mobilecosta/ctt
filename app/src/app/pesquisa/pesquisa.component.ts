import { Component, OnInit } from '@angular/core';
import { PoDynamicFormField, PoDynamicFormLoad } from '@po-ui/ng-components';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { ActivatedRoute } from '@angular/router';
import { PoNotificationService } from '@po-ui/ng-components';
import { environment } from 'src/environments/environment';
import { PoStorageService } from '@po-ui/ng-storage';
import { NgForm, NgModelGroup } from '@angular/forms';
@Component({
  selector: 'app-pesquisa',
  templateUrl: './pesquisa.component.html',
  styleUrls: ['./pesquisa.component.scss']
})


export class PesquisaComponent implements OnInit {

  title = 'Pesquisas'
  dynamicForm: NgForm;
  respotas: [];
  url_post = environment.api + '/grava';
  cod_turma: any;
  fields: Array<PoDynamicFormField>;
  filedstemp = []
  count: number = 0;



  constructor(private storage: PoStorageService,private httpClient: HttpClient, private activatedRoute: ActivatedRoute, private notify: PoNotificationService) {
    // this.fields = [

    //   {
    //     property: 'pergunta1',
    //     label:'1.0.1 Pontualidade(Inicio e termino de aula, saida  e retorno para avaliação)?',
    //     divider: 'Pergunta 01 Instrutor',
    //     gridColumns: 10,
    //     gridSmColumns: 15,
    //     fieldValue: '',
    //     optional: false,
    //     options: ['1', '2', '3', '4', '5', '6', '7','8','9','10']
    //   },
    //   {
    //     property: 'pergunta2',
    //     label:'1.0.2 Habilitar em promover a participação do grupo e/ou aluno?',
    //     gridColumns: 10,
    //     gridSmColumns: 15,
    //     optional: false,
    //     options: ['1', '2', '3', '4', '5', '6', '7','8','9','10']
    //   }
    // ]
    let url = environment.api + 'api/montagem/?{000001,01}'
    this.httpClient.get(url).subscribe((res)=>{
      var [pesquisa] = [res['aPesq']]

      pesquisa.forEach(element => {
        console.log(element)
          if(element['PD5_ASSUNTO'] == '0'){
            this.filedstemp.push({
              property: `${this.count}`,
              label: `${element['PD5_PERGUN']}`,
              divider: 'Pergunta 01 Instrutor',
              gridColumns: 10,
              gridSmColumns: 15,
              rows: 5,
              placeholder: 'coloque seu texto'
            })
          }else{
            this.filedstemp.push({
            property: `${this.count}`,
            label: `${this.count}`+`${element['PD5_PERGUN']}`,
            divider: 'Pergunta 01 Instrutor',
            gridColumns: 10,
            gridSmColumns: 15,
            fieldValue: '',
            optional: false,
            options: ['1', '2', '3', '4', '5']
          })
          }
        this.count+=1
        });
        this.fields = this.filedstemp;

    }, (err)=>{
      console.log(err)
    })

   /* this.storage.get('pergunta').then(turma=> this.cod_turma = turma['turma'])
      this.storage.get('user').then((value1)=>{
        console.log(value1)
        value1.aCursos.forEach((element) => {
          this.httpClient.post(this.url_post, {
            "PD4_ALUNO": value1['PDL_ALUNO'],
            "PD4_PERIO": element['PDF_PERIO'],
          "PD4_TURMA": this.cod_turma,
          "PD4_PROF": value1['PDL_NOME'],
          "PD4_PESQ": 'codigo da pesquisa',
          "PD4_DTCURS": `${element['PDF_DTINI']}  até ${element['PDF_DTFIM']}`,
          "respostas": this.respotas // respostas deve ser um array com os campos identicos ao requeridos a api e o valor vindo do form controll
          }).subscribe((success)=> {
            console.log('success')
          }, (error)=>{
            console.log('error')
          })
        });
      }) */

  }
  getForm(form: NgForm) {
    console.log(this.dynamicForm)
}

  onLoadFields(): PoDynamicFormLoad {
    console.log('dsds');
    return {
      value: { property: 'pergunta2' },
      fields: [
        { property: 'pergunta1' }
      ]
    };

  }



  ngOnInit() {
/*
    this.storage.get('perguntas').then((res)=>{
      console.log(res)
      this.fields.push({
        property: '1.0.1 Pontualidade(Inicio e termino de aula, saida  e retorno para avaliação)?',
      divider: 'Pergunta 01 Instrutor',
      gridColumns: 10,
      gridSmColumns: 15,
      optional: false,
      options: ['1', '2', '3', '4', '5', '6', '7','8','9','10']
      })
    })
*/
  }

}
