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

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css'],
  providers: [SamplePoPageDynamicTableUsersService]


})
export class HomeComponent implements OnInit {
  detailedUser: any;
  serviceApi(usersService: SamplePoPageDynamicTableUsersService, serviceApi: any): string | ((resources?: any) => void) {
    throw new Error('Method not implemented.');
  }
  @ViewChild('userDetailModal') userDetailModal: PoModalComponent;



  private readonly API ='http://localhost:3000/login';
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

  readonly breadcrumb: PoBreadcrumb = {
    items: [{ label: '', link: '/' }, { label: '' }]
  };



  readonly fields: Array<any> = [
    { property: 'id', key: true, visible: false, filter: true },
    { property: 'datas', label: 'Datas', filter: true, gridColumns: 6 },
    { property: 'curso', label: 'Cursos', filter: true, gridColumns: 6, duplicate: true },
    { property: 'turma', label: 'Turma', filter: true, gridColumns: 6, duplicate: true },
    { property: 'sala', label: 'Sala', filter: true, gridColumns: 6, duplicate: true },
    { property: 'professor', label: 'Professor', filter: true, gridColumns: 6, duplicate: true },


    { property: 'search', filter: true, visible: false },
    {
      property: 'birthdate',
      label: 'Birthdate',
      type: 'date',
      gridColumns: 6,
      visible: false,
      allowColumnsManager: true
    },
  //  { property: 'city', label: 'City', filter: true, duplicate: true, options: this.cityOptions, gridColumns: 12 }
  ];

  readonly detailFields: Array<PoDynamicViewField> = [
    { property: 'status', tag: true, gridLgColumns: 4, divider: 'Personal Data' },
    { property: 'name', gridLgColumns: 4 },
    { property: 'nickname', label: 'User name', gridLgColumns: 4 },
    { property: 'email', gridLgColumns: 4 },
    { property: 'birthdate', gridLgColumns: 4, type: 'date' },
    { property: 'genre', gridLgColumns: 4, gridSmColumns: 6 },
    { property: 'cityName', label: 'City', divider: 'Address' },
    { property: 'state' },
    { property: 'country' }
  ];

  pageCustomActions: Array<PoPageDynamicTableCustomAction> = [
    { label: 'Print', action: this.printPage.bind(this) },
    { label: 'Download .csv', action: this.usersService.downloadCsv.bind(this.usersService, this.serviceApi) }
  ];

  tableCustomActions: Array<PoPageDynamicTableCustomTableAction> = [
    { label: 'Details', action: this.onClickUserDetail.bind(this) }
  ];


  onLoad(): PoPageDynamicTableOptions {
    return {
      fields: [
        { property: 'id', key: true, visible: true, filter: true },
        { property: 'name', label: 'Name', filter: true, gridColumns: 6 },
        { property: 'genre', label: 'Genre', filter: true, gridColumns: 6, duplicate: true },
        { property: 'search', initValue: '0748093840433' },
        {
          property: 'birthdate',
          label: 'Birthdate',
          type: 'date',
          gridColumns: 6,
          visible: false,
          allowColumnsManager: true
        }
      ]
    };
  }

  printPage() {
    window.print();
  }

  private onClickUserDetail(user) {
    this.detailedUser = user;

    this.userDetailModal.open();
  }
}




function createReactiveForm() {
}


