import { HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';

import { RequestApiList } from './request-api-list';

@Injectable({
  providedIn: 'root',
})
export class ApiService {
  constructor() {}

  public listParams(params: RequestApiList): HttpParams {
    return params.buildHttpParams();
  }
}
