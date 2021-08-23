import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { PoStorageService } from '@po-ui/ng-storage';
import { HttpClient, HttpHeaders } from '@angular/common/http';

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
        var curso = datajson.aCursos

        datajson.aCursos.forEach((value,index) => {


          console.log(datajson.aCursos);
          this.data.push(
            {

            datas: `${value['PDF_DTINI']}  até ${value['PDF_DTFIM']}`,
            curso: value['PD3_NOME'],
            turma: value['PD7_TURMA'],
            sala: value['PD3_SALA'],
            professor:value['PD2_NOME']
          });



        });

        console.log(this.data);
      },
      (error)=>{

        console.log(error);


      }
      )

   }

  ngOnInit(): void {

  }

  rowActions = {

  };

  columns = [
    { property: 'datas', label: 'Datas', width:'50px',required:true},
    { property: 'curso', label: 'Curso', align:'center', width: '100px' },
    { property: 'turma', label: 'Turma', width: 80 },
    { property: 'sala', label: 'Sala', width: 100,  },
    { property: 'professor', label: 'Professor', width: 100, required: true }
  ];

  data = [
      ];

  onBeforeSave(row: any, _old: any) {
    return row.occupation !== 'Engineer';
  }

  logout(): void {
  };

}
