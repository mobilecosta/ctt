import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { take } from 'rxjs/operators';

import { environment } from '@env/environment';
import { Customer } from './customer';

@Injectable({
  providedIn: 'root',
})
export class CustomerService {
  private readonly endpoint = `${environment.api}customers`;

  constructor(private http: HttpClient) {}

  getById(id: number): Observable<Customer> {
    return this.http.get<Customer>(`${this.endpoint}/${id}`).pipe(take(1));
  }
}
