import { Component, OnInit } from '@angular/core';
import { PoDynamicFormField, PoDynamicFormLoad } from '@po-ui/ng-components';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { ActivatedRoute } from '@angular/router';
import { PoNotificationService } from '@po-ui/ng-components';
import { environment } from 'src/environments/environment';

@Component({
  selector: 'app-pesquisa',
  templateUrl: './pesquisa.component.html',
  styleUrls: ['./pesquisa.component.scss']
})

export class PesquisaComponent implements OnInit {

  title = 'Pesquisas'

  constructor(private httpClient: HttpClient, private activatedRoute: ActivatedRoute, private notify: PoNotificationService) {

  }

  ngOnInit() {
  }

  fields: Array<PoDynamicFormField> = [
    {
      property: '1.0.1 Pontualidade(Inicio e termino de aula, saida  e retorno para avaliação)?',
      divider: 'Pergunta 01 Instrutor',
      gridColumns: 10,
      gridSmColumns: 15,
      optional: false,
      options: ['1', '2', '3', '4', '5', '6', '7','8','9','10']
    },

    {
      property: '1.0.2 Habilitar em promover a participação do grupo e/ou aluno?',
      gridColumns: 10,
      gridSmColumns: 15,
      optional: false,
      options: ['1', '2', '3', '4', '5', '6', '7','8','9','10']
    },

    {
      property: '1.0.3 Clareza e concisão de raciocinio e linguagem(O assunto explicado foi compreensivel)?',
      gridColumns: 10,
      gridSmColumns: 15,
      optional: false,
      options: ['1', '2', '3', '4', '5', '6', '7','8','9','10']
    },

    {
      property: '1.0.4 Conhecimento sobre o assunto abordado atendeu as expectativas?',
      gridColumns: 10,
      gridSmColumns: 15,
      optional: false,
      options: ['1', '2', '3', '4', '5', '6', '7','8','9','10']
    },

    {
      property: '1.0.5 Postura(Educação,Cordialidade,Etica)?',
      gridColumns: 10,
      gridSmColumns: 15,
      optional: false,
      options: ['1', '2', '3', '4', '5', '6', '7','8','9','10'],

    },

    {
      property:'2.0.1 Conteudo programatico foi apresentado e seus topicos abordados? ' ,
      divider:'Pergunta 02 Material-Didático',
      gridColumns: 10,
      gridSmColumns: 15,
      optional: false,
      options: ['1', '2', '3', '4', '5', '6', '7','8','9','10']
    },

    {
      property:'2.0.2 Exercicios praticos no sistema(Promeveram fixacao do aprendizado)?' ,
      gridColumns: 10,
      gridSmColumns: 15,
      optional: false,
      options: ['1', '2', '3', '4', '5', '6', '7','8','9','10']
    },

    {
      property:'2.0.3 Material Didatico(Apostila e/ou Material complementar) Adequado para consultas?' ,
      gridColumns: 10,
      gridSmColumns: 15,
      optional: false,
      options: ['1', '2', '3', '4', '5', '6', '7','8','9','10']
    },


    {
      property:'2.0.4 Roteiro de Aprendizado(Apresentação das informacoes foi de facil compreensao?',
      gridColumns: 10,
      gridSmColumns: 15,
      optional: false,
      options: ['1', '2', '3', '4', '5', '6', '7','8','9','10']
    },

  ];

}
