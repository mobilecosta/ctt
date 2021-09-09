import { Component, OnInit } from '@angular/core';
import { PoDynamicFormField, PoDynamicFormLoad } from '@po-ui/ng-components';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';
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
  isHideLoading = false;
  title = 'Pesquisas'
  dynamicForm: NgForm;
  respostas = [];
  url_post = environment.api + 'api/grava';
  fields: Array<PoDynamicFormField>;
  filedstemp = []
  count: number = 0;
  turma: string;
  periodo: string;

  constructor(private storage: PoStorageService,
              private httpClient: HttpClient,
              private router: Router,
              private notify: PoNotificationService) {

    this.storage.get('pergunta').then(turma=> this.turma = turma['turma'], turma=> this.periodo = turma['periodo']);
    let url = environment.api + 'api/montagem/?{' + this.turma + ',' + this.periodo + '}';
    this.httpClient.get(url).subscribe((res)=>{
      var [pesquisa] = [res['aPesq']]

      pesquisa.forEach(element => {
          if(element['PD5_ASSUNTO'] == '2'){
            this.filedstemp.push({
              property: `${this.count}`,
              label: `${this.count}: `+`${element['PD5_PERGUN']}`,
              divider: `${element['PD5_FINALI_D']}`,
              gridColumns: 10,
              gridSmColumns: 15,
              rows: 5,
              key: element['PD5_ITEM'],
              placeholder: 'coloque seu texto'
            })
          }else{
            this.filedstemp.push({
            property: `${this.count}`,
            label: `${this.count}: `+`${element['PD5_PERGUN']}`,
            divider: `${element['PD5_FINALI_D']}`,
            gridColumns: 10,
            gridSmColumns: 15,
            required: true,
            minLength: 1,
            fieldValue: ' ',
            key: element['PD5_ITEM'],
            options: [  { label: '', value: '' }, { label: 'Nota 1', value: '1' }, { label: 'Nota 2', value: '2' },
                        { label: 'Nota 3', value: '3' }, { label: 'Nota 4', value: '4' }, { label: 'Nota 5', value: '5' }]
          })
          }
        this.count+=1
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

  ngOnInit() {
  };

  onClick() {
    var icount: number = 0;
    this.fields.forEach((element) => {
      this.respostas.push(this.dynamicForm.controls[icount].value)
      icount += 1;
    }
    );
    var result = this.respostas.every(e => e !== undefined)
    if(result){
      this.storage.get('user').then((value1)=>{
        value1.aCursos.forEach((element) => {
          this.httpClient.post(this.url_post, {
            "PD4_ALUNO": value1['aluno'],
            "PD4_TURMA": value1['turma'],
            "PD4_PERIO": value1['periodo'],
            "PD4_PROF": value1['professor'],
            "PD4_PESQ": value1['pesquisa'],
            "PD4_DTCURS": value1['inicio'],
            "respostas": this.respostas // respostas deve ser um array com os campos identicos ao requeridos a api e o valor vindo do form controll
          }).subscribe((success)=> {
            this.router.navigate([`/sucess`]);
          }, (error)=>{
            window.alert('Erro na gravação das perguntas ' + error["msg"]);
          })
        });
      })
    }else{
      this.notify.error("Todos os campos devem ser preenchidos!")
    }
  }


}
