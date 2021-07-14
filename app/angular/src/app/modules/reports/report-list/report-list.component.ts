import { Observable, Subscription } from 'rxjs';
import { Component, OnInit, OnDestroy, ViewChild } from '@angular/core';
import {
  PoTableColumn,
  PoPageAction,
  PoBreadcrumb,
  PoPageFilter,
  PoModalComponent
} from '@po-ui/ng-components';

import { HomeService } from './../../../layout/home/home.service';
import { ResponseApiList } from '@shared/response-api-list';
import { Report } from '../report';
import { ReportService } from './../report.service';
import { take } from 'rxjs/operators';
import { RequestApiList, RequestApiListParams } from '@shared/request-api-list';

@Component({
  selector: 'app-report-list',
  templateUrl: './report-list.component.html',
  styleUrls: ['./report-list.component.scss'],
})
export class ReportListComponent implements OnInit, OnDestroy {
  private subscriptions: Array<Subscription> = [];
  private reports$?: Observable<ResponseApiList<Report>>;
  private reports: Array<Report> = [];
  private page = 1;
  private searchTerm = '';

  public loading = true;
  public title = 'Laudos';
  public pageActions: Array<PoPageAction> = [];
  public hasNext = false;
  public columns: Array<PoTableColumn> = [];
  public items: Array<any> = [];

  public readonly breadCrumbe: PoBreadcrumb = {
    items: [
      { label: 'Home', link: '/dash' },
      { label: this.title, link: '/reports' },
    ],
  };

  // NOVO OBJETO PARA CONTROLAR O MECANISMO DE PESQUISA
  public readonly filter: PoPageFilter = {
    action: this.actionSearch.bind(this),
    ngModel: 'searchTerm',
    placeholder: 'Pesquisar por ...',
  };

  constructor(
    private homeService: HomeService,
    private service: ReportService
  ) {
    this.homeService.homeData = {
      title: this.title,
      icon: 'po-icon-document',
      routeUrl: 'reports',
    };
  }

  ngOnInit(): void {
    this.columns = this.service.columns;
    this.refresh();
    this.pageActions = [
      {
        label: 'Exportar',
        action: () => this.refresh(),
        icon: 'po-icon-export',
      },
    ];
  }

  ngOnDestroy(): void {
    this.subscriptions.forEach(subscription => subscription.unsubscribe);
  }

  refresh(): void {
    this.loadData();
  }

  actionSearch(): void {
    this.page = 1;
    this.reports = [];
    this.loadData({ page: this.page, searchTerm: this.searchTerm });
  }

  showMore(): void {
    this.loadData({ page: ++this.page, searchTerm: this.searchTerm });
  }

  loadData(params: RequestApiListParams = {}): void {
    console.log(this.page);

    console.log(params);
    this.loading = true;
    this.reports$ = this.service.list(new RequestApiList(params));
    this.subscriptions.push(
      this.reports$.subscribe((data: ResponseApiList<Report>) =>  {
        this.reports = [...this.reports, ...data.items];
        this.hasNext = data.hasNext;
        this.loading = false;
        this.refreshItems();
      })
    );
  }

  private refreshItems(): void {
    this.items = this.reports.map(report => {
      return {
        id: report.id,
        sample: report.sample,
        created: report.created,
        emmited: report.emmited,
        nextcollect: report.nextCollect,
        diagnostic: report.diagnostic,
        recommendation: report.recommendation,
        sign: report.sign,
        note: report.note,
        critlabel: report.criticality.label,
        critlevel: report.criticality.level,
      };
    });
  }
}
