import { Router } from '@angular/router';
import { PoStorageService } from '@po-ui/ng-storage';
import { PoMenuItem } from '@po-ui/ng-components';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Component, OnInit,ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, NgForm, Validators } from '@angular/forms';
import { PoBreadcrumb, PoDynamicViewField, PoModalComponent } from '@po-ui/ng-components';

import { PoComboOption, PoComboOptionGroup, PoNotificationService, PoSelectOption } from '@po-ui/ng-components';
import { Subscription } from 'rxjs';
import { getMaxListeners } from 'process';
import {
  PoPageDynamicTableActions,
  PoPageDynamicTableCustomAction,
  PoPageDynamicTableCustomTableAction,
  PoPageDynamicTableOptions
} from '@po-ui/ng-templates';

import { SamplePoPageDynamicTableUsersService } from './home.service';
import { Button } from 'protractor';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css'],
  providers: [SamplePoPageDynamicTableUsersService]


})
export class HomeComponent implements OnInit {
  detailedUser: any;
  printPage: any;
  serviceApi(usersService: SamplePoPageDynamicTableUsersService, serviceApi: any): string | ((resources?: any) => void) {
    throw new Error('Method not implemented.');
  }
  @ViewChild('userDetailModal') userDetailModal: PoModalComponent;



  private readonly API ='https://api.conceitho.com/api/protheus/';
  private chamada!: Subscription;
  private headers!: HttpHeaders;
  httpClient: any;
  reactiveForm: any;
  fb: any;
  loginForm: any;
  cadastro: FormGroup;

  constructor(private router: Router, private storage: PoStorageService, htppCliente:HttpClient, private formBuilder:FormBuilder,private usersService: SamplePoPageDynamicTableUsersService) { }

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
  readonly actions: PoPageDynamicTableActions = {
    new: '/documentation/po-page-dynamic-edit',
    remove: true,
    removeAll: true

  };

//  readonly breadcrumb: PoBreadcrumb = {
  //  items: [{ label: '', link: '/' }, { label: '' }]
//  };




  readonly fields: Array<any> = [
    { property: 'id', key: true, visible: false, filter: true },
    { property: 'datas', label: 'Datas', filter: true, gridColumns: 6 },
    { property: 'curso', label: 'Cursos', filter: true, gridColumns: 6},
    { property: 'turma', label: 'Turma', filter: true, gridColumns: 6 },
    { property: 'sala', label: 'Sala', filter: true, gridColumns: 6},
    { property: 'professor', label: 'Professor', filter: true, gridColumns: 6}


 //  { property: 'search', filter: true, visible: false },
   /* {
      property: 'birthdate',
      label: 'Birthdate',
      type: 'date',
      gridColumns: 6,
      visible: false,
      allowColumnsManager: true
    },
  //  { property: 'city', label: 'City', filter: true, duplicate: true, options: this.cityOptions, gridColumns: 12 }
  */];

// readonly detailFields: Array<PoDynamicViewField> = [
    //{ property: 'id', key: true, visible: true,  },
    //{ property: 'datas', label: 'Datas',  gridColumns: 6 },
    //{ property: 'curso', label: 'cursos',  gridColumns: 6},
    //{ property: 'turma', label: 'Turma',  gridColumns: 6},
   // { property: 'sala', label: 'Sala',  gridColumns: 6},
 //   { property: 'professor', label: 'Professor',  gridColumns: 6},

  //];

 pageCustomActions: Array<PoPageDynamicTableCustomAction> = [
  { label: 'Selecionar'},
  ];

  tableCustomActions: Array<PoPageDynamicTableCustomTableAction> = [
    { label: 'Details', action: this.onClickUserDetail.bind(this) }
  ];


  onLoad(): PoPageDynamicTableOptions {
    return {
      fields: [
        { property: 'id', key: true, visible: true, filter: true },
        { property: 'datas', label: 'Datas', filter: true, gridColumns: 6 },
        { property: 'curso', label: 'Cursos', filter: true, gridColumns: 6,},
        { property: 'turma', label: 'Turma', filter: true, gridColumns: 6,},
        { property: 'sala', label: 'Sala', filter: true, gridColumns: 6,},
        { property: 'professor', label: 'Professor', filter: true, gridColumns: 6, duplicate:true},

      ]
    };
  }


  private onClickUserDetail(user) {
    this.detailedUser = user;

    this.userDetailModal.open();  }

    url='http://localhost:3000/aCursos';

  private loadData(params: { page?: number, search?: string } = { }) {

    this.httpClient.get(this.url, { headers: this.headers, params: <any>params })
      .subscribe((response: any) => {


      });



  }



 }











function createReactiveForm() {
}


