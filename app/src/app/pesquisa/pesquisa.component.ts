import { Component, OnInit } from '@angular/core';
import { PoDynamicFormField, PoDynamicFormLoad } from '@po-ui/ng-components';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { ActivatedRoute } from '@angular/router';
import { PoNotificationService } from '@po-ui/ng-components';
import { environment } from 'src/environments/environment';
import { PoStorageService } from '@po-ui/ng-storage';
import { NgForm } from '@angular/forms';
@Component({
  selector: 'app-pesquisa',
  templateUrl: './pesquisa.component.html',
  styleUrls: ['./pesquisa.component.scss']
})

export class PesquisaComponent implements OnInit {

  title = 'Pesquisas'
  dynamicForm: NgForm;


  constructor(private storage: PoStorageService,private httpClient: HttpClient, private activatedRoute: ActivatedRoute, private notify: PoNotificationService) {
/*
    this.storage.get('pergunta').then((res)=>{
      var url = environment.api + `api/montagem/?{${res.turma},${res.sala}}`
      this.httpClient.get(url).subscribe((element)=>{
        this.storage.set('perguntas', element).then(e => console.log(e))
      },(res)=>{})
    })
*/
  }

  onLoadFields(): PoDynamicFormLoad {

    return {
      value: { cpf: undefined },
      fields: [
        { property: 'cpf' }
      ],
      focus: 'cpf'
    };

  }

  fields: Array<PoDynamicFormField> = [

    {
      property: 'pergunta1',
      label:'1.0.1 Pontualidade(Inicio e termino de aula, saida  e retorno para avaliação)?',
      divider: 'Pergunta 01 Instrutor',
      gridColumns: 10,
      gridSmColumns: 15,
      optional: false,
      options: ['1', '2', '3', '4', '5', '6', '7','8','9','10']
    },
    {
      property: 'pergunta2',
      label:'1.0.2 Habilitar em promover a participação do grupo e/ou aluno?',
      gridColumns: 10,
      gridSmColumns: 15,
      optional: false,
      options: ['1', '2', '3', '4', '5', '6', '7','8','9','10']
    }
  ]

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
