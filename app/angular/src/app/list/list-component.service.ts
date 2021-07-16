import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ListComponent } from './list.component';

@Injectable({
  providedIn: 'root'
})
export class ListComponentService {
  private readonly API ='http://localhost:3000/curso';

  constructor( private http:HttpClient) { }


  list(){

    return this.http.get<ListComponent[]> (this.API);
  }
}
