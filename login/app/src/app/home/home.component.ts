import { Router } from '@angular/router';
import { PoStorageService } from '@po-ui/ng-storage';
import { PoMenuItem } from '@po-ui/ng-components';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Component, OnInit,ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, NgForm, Validators } from '@angular/forms';

import { PoComboOption, PoComboOptionGroup, PoNotificationService, PoSelectOption } from '@po-ui/ng-components';
import { Subscription } from 'rxjs';
import { getMaxListeners } from 'process';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  private readonly API ='http://localhost:3000/login';
  private chamada!: Subscription;
  private headers!: HttpHeaders;
  httpClient: any;
  reactiveForm: any;
  fb: any;
  loginForm: any;
  cadastro: FormGroup;

  constructor(private router: Router, private storage: PoStorageService, htppCliente:HttpClient, private formBuilder:FormBuilder) { }

  title = 'Integração Protheus';

  menus: Array<PoMenuItem> = [
    { label: 'Home', link: '/home', icon: 'po-icon-home', shortLabel: 'Principal' },
    { label: 'Usuarios', link: './users', icon: 'po-icon-finance', shortLabel: 'Usuários' },
    { label: 'ConsultaCNPJ', link: './cnpj', icon: 'po-icon po-icon-company', shortLabel: 'ConsultaCNPJ' },
  ];


  ngOnInit(): void {
    this.chamada = this.httpClient.get(this.API, { headers: this.headers })
    .subscribe((response: any) => {
      alert('Retornei');
    })
    this.configurarcadastro();
  /*   this.loginForm = this.fb.group({
     email:[
     '',
     [
       Validators.required,
       Validators.pattern('^[0.9]{11}$'),
       Validators.maxLength(11),

     ]


     ]


     })

    */
    ;



  }

  configurarcadastro(){

    this.cadastro =this.formBuilder.group({
    cpfnome:[null,Validators.required,[Validators.pattern('^[0-9]{11}$')]],
    email:[null,[Validators.required,Validators.email ]],
    empresa:[null,Validators.required]



    });

  }
  rowActions = {
    beforeSave: this.onBeforeSave.bind(this),
    afterSave: this.onAfterSave.bind(this),
    beforeRemove: this.onBeforeRemove.bind(this),
    afterRemove: this.onAfterRemove.bind(this),
    beforeInsert: this.onBeforeInsert.bind(this)
  };



  columns = [
    { property: 'datas', label: 'Datas', align: 'center', width: 140 },
    { property: 'curso', label: 'Curso', width: '150px', required: true },
    { property: 'turma', label: 'Turma', width: 80 },
    { property: 'sala', label: 'Sala', width: 100,  },
    { property: 'professor', label: 'Professor', width: 100, required: true },


  ];

  data = [
    {
      datas: '2018-12-12',
      curso: 'Configurador',
      turma: '01',
      sala:'A',
      professor: 'João',

    }
      ];

  onBeforeSave(row: any, _old: any) {
    return row.occupation !== 'Engineer';
  }

  onAfterSave(_row: any) {
    // console.log('onAfterSave(new): ', row);
  }

  onBeforeRemove(_row:any) {
    // console.log('onBeforeRemove: ', row);

    return true;
  }

  onAfterRemove(_row:any) {
    // console.log('onAfterRemove: ', row);
  }

  onBeforeInsert(_row:any) {
    // console.log('onBeforeInsert: ', row);

    return true;

  }


}

function createReactiveForm() {
  throw new Error('Function not implemented.');
}

