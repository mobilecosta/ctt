import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';

import { PoTableColumn } from '@po-ui/ng-components';
import { environment } from '@env/environment';

import { Report } from './report';
import { ResponseApiList } from '@shared/response-api-list';
import { RequestApiList } from '@shared/request-api-list';
import { take } from 'rxjs/operators';

@Injectable({
  providedIn: 'root',
})
export class ReportService {
  private readonly endPoint: string = `${environment.api}reports`;
  private hasNextRerpots = false;
  constructor(private http: HttpClient) {}

  list(
    params: RequestApiList = new RequestApiList()
  ): Observable<ResponseApiList<Report>> {
    const httpParams: HttpParams = params.buildHttpParams();

    return this.http
      .get<ResponseApiList<Report>>(this.endPoint, {
        params: httpParams,
      })
      .pipe(take(1));
  }

  get columns(): Array<PoTableColumn> {
    return [
      // {
      //   property: 'critlevel',
      //   label: 'Status',
      //   type: 'subtitle',
      //   subtitles: [
      //     { value: 'NORMAL', color: 'color-11', content: 'N', label: 'Normal' },
      //     { value: 'WARNING', color: 'color-08', content: 'A', label: 'Atenção' },
      //     { value: 'CRITICAL', color: 'color-07', content: 'C', label: 'Crítico' },
      //   ],
      // },
      {
        property: 'critlevel',
        label: 'Status',
        type: 'label',
        width: '80px',
        labels: [
          { value: 'NORMAL', color: 'color-11', label: 'Normal' },
          { value: 'WARNING', color: 'color-08', label: 'Atenção' },
          { value: 'CRITICAL', color: 'color-07', label: 'Crítico' },
        ],
      },
      { property: 'critlabel', label: 'Criticidade' },
      { property: 'id', label: 'Laudo' },
      { property: 'sample', label: 'Amostra', type: 'link', link: '/samples' },
      { property: 'created', label: 'Criado', type: 'date' },
      { property: 'emmited', label: 'Emitido', type: 'date' },
      { property: 'nextcollect', label: 'Próxima Coleta', type: 'date' },
      { property: 'diagnostic', label: 'Diagnóstico', type: 'string' },
      {
        property: 'recommendation',
        label: 'Recomendação',
        type: 'string',
        visible: false,
      },
      { property: 'sign', label: 'Assinatura', type: 'string', visible: false },
      { property: 'note', label: 'Observação', type: 'string', visible: false },
    ];
  }

  // get items(): Array<any> {
  //   return this.reports.map((report, index) => {
  //     return {
  //       id: report.id,
  //       sample: report.sample,
  //       created: report.created,
  //       emmited: report.emmited,
  //       nextcollect: report.nextCollect,
  //       diagnostic: report.diagnostic,
  //       recommendation: report.recommendation,
  //       sign: report.sign,
  //       note: report.note,
  //       critlabel: report.criticality.label,
  //       critlevel: report.criticality.level,
  //     };
  //   });
  // }

  get hasNext(): boolean {
    return this.hasNextRerpots;
  }
}
