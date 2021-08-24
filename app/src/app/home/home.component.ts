import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { PoStorageService } from '@po-ui/ng-storage';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { PoDynamicViewField } from '@po-ui/ng-components';
import { PoPageDynamicTableOptions } from '@po-ui/ng-templates';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent {

  title = 'Portal Pesquisa Satisfação (CTT)';



  constructor(private router: Router, private storage: PoStorageService, private httpClient: HttpClient) {



    this.httpClient.get('http://172.24.50.16:8044/CTT/api/login/26277712802') .subscribe (

      (datajson)=>{
     var curso = datajson.aCursos         //Variavel criado a partir do Json.
      datajson.aCursos.forEach((value,index) => {            //Foreach para percorrer o caminho do Json a cursos.


         // console.log(datajson.aCursos);
          this.data.push(                        // push para adicionar no front end os dados da Api Json.
            {

            datas: `${value['PDF_DTINI']}  até ${value['PDF_DTFIM']}`,   // Concatenação dos dados da APi 'PDF_Ini até 'PDF_Ini'
            curso: value['PD3_NOME'],    // PD3_Nome (nome do campo API.)
            turma: value['PD7_TURMA'],
            sala: value['PD3_SALA'],
            professor:value['PD2_NOME']
          });



        });



      }
      )

   }

  ngOnInit(): void {

  }

  rowActions = {

  };

  columns = [



    { property: 'status', tag: true, gridLgColumns: 4, divider: 'Personal Data', booleanTrue:"" ,checkbox:""},




    { property: 'datas', label: 'Datas', width:'50px',required:true},
    { property: 'curso', label: 'Curso', align:'center', width: '100px' },
    { property: 'turma', label: 'Turma', width: 150 },
    { property: 'sala', label: 'Sala', width: 150,  },
    { property: 'professor', label: 'Professor', width: 400, required: true }
  ];

  data = [
      ];

  onBeforeSave(row: any, _old: any) {
    console.log(row)
    return row.occupation !== 'Engineer';
  }



    onClick() {
     // alert('input[name=radioName]:checked');
     window.location.href = "http://localhost:4200/perguntas"

    }


  logout(): void {
  };

}
