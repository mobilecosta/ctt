import { Component, OnInit } from '@angular/core';

import { HomeService } from './../../layout/home/home.service';
import { PoBreadcrumb } from '@po-ui/ng-components';

@Component({
  selector: 'app-dash-board',
  templateUrl: './dash-board.component.html',
  styleUrls: ['./dash-board.component.scss'],
})
export class DashBoardComponent implements OnInit {
  title = 'Dashboard';
  icon = 'po-icon-home';
  constructor(private homeService: HomeService) {
    this.homeService.homeData = {
      title: this.title,
      icon: this.icon,
      routeUrl: 'dash',
    };
  }

  public readonly breadCrumbe: PoBreadcrumb = {
    items: [
      { label: 'Home', link: 'dash' },
      { label: this.title, link: 'dash' },
    ],
  };

  ngOnInit(): void {}
}
