import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Subscription } from 'rxjs';
import { ListComponent } from './list.component';

@Injectable({
  providedIn: 'root'
})
export class ListComponentService {
  private readonly API ='http://localhost:3000/curso';
  private chamada!: Subscription;
  private headers!: HttpHeaders;

  constructor( private httpClient: HttpClient) { }


  list(){
    this.headers = new HttpHeaders();

    this.chamada = this.httpClient.get(this.API, { headers: this.headers })
    .subscribe((response: any) => {
      alert('Retornei');
    });
  }
}
