import { HttpParams } from '@angular/common/http';

export interface RequestApiListParams {
  page?: number;
  pageSize?: number;
  searchTerm?: string;
  order?: Array<string>;
  filter?: Map<string, string>;
}

export class RequestApiList {
  private httpParams: HttpParams;
  constructor(private data: RequestApiListParams = {}) {
    this.httpParams = new HttpParams();
  }

  public buildHttpParams(): HttpParams {
    return this.setPagination().setSearch().setOrder().setFilter().build();
  }

  private setPagination(): RequestApiList {
    this.httpParams = this.httpParams
      .set('page', this.data.page ? String(this.data.page) : '1')
      .set('pagesize', this.data.pageSize ? String(this.data.pageSize) : '15');

    return this;
  }

  private setSearch(): RequestApiList {
    if (this.data.searchTerm) {
      this.httpParams = this.httpParams.set('search', this.data.searchTerm);
    }
    return this;
  }

  private setOrder(): RequestApiList {
    if (this.data.order) {
      this.httpParams = this.httpParams.set(
        'order',
        this.data.order.toString()
      );
    }

    return this;
  }

  private setFilter(): RequestApiList {
    if (this.data.filter) {
      const filter: Array<string> = [];
      this.data.filter.forEach((vl, fd) => filter.push(`${fd}=${vl}`));
      if (filter.length > 0) {
        this.httpParams = this.httpParams.set('filter', filter.toString());
      }
    }
    return this;
  }

  private build(): HttpParams {
    return this.httpParams;
  }
}
