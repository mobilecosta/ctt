import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

import { HomeData } from './home-data';

@Injectable({
  providedIn: 'root',
})
export class HomeService {
  private iHomeData = new BehaviorSubject<HomeData>({
    title: 'DashBoard',
    icon: 'po-icon-home',
    routeUrl: '',
  });

  constructor() {}

  get homeData(): HomeData {
    return this.iHomeData.value;
  }

  set homeData(homeData: HomeData) {
    this.iHomeData.next(homeData);
  }
}
