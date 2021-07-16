import { Component, OnInit,ViewChild } from '@angular/core';
import { NgForm } from '@angular/forms';

import { ListComponentService } from './list-component.service';
import { PoComboOption, PoComboOptionGroup, PoNotificationService, PoSelectOption } from '@po-ui/ng-components';

@Component({
  selector: 'app-list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.scss'],
  preserveWhitespaces:true
})
export class ListComponent implements OnInit {



  constructor(private  service: ListComponentService){}

  ngOnInit(): void {
    this.service.list().subscribe(console.log);

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
