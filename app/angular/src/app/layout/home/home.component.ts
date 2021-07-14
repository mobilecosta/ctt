import { Component, OnInit, OnDestroy } from '@angular/core';
import { Observable, Subscription } from 'rxjs';
import {
  PoMenuItem,
  PoBreadcrumb,
  PoToolbarProfile,
  PoToolbarAction,
} from '@po-ui/ng-components';

import { HomeService } from './home.service';
import { LoginService } from '@app/security/login/login.service';
import { LoginToken } from '@app/security/login/login-token';
import { CustomerService } from '@app/customers/customer.service';
import { Customer } from '@app/customers/customer';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss'],
})
export class HomeComponent implements OnInit, OnDestroy {
  private subscription?: Subscription;
  showMenu = false;
  appname = 'Lorencini Brasil';
  logo = 'assets/images/logo.png';
  loginSubject$?: Observable<LoginToken>;

  public readonly profileActions: PoToolbarAction[] = [];
  public profile?: PoToolbarProfile;

  public readonly breadCrumbe: PoBreadcrumb = {
    items: [
      { label: 'Home', link: 'dash' },
      { label: this.title, link: this.routerUrl },
    ],
  };

  readonly menus: Array<PoMenuItem> = [
    { label: 'Dashboard', icon: 'po-icon-home', link: 'dash', shortLabel: 'Dash' },
    { label: 'Laudos', icon: 'po-icon-document', link: 'reports', shortLabel: 'Laudos' },
  ];

  constructor(
    private homeService: HomeService,
    private loginService: LoginService,
    private customerService: CustomerService
  ) {}

  ngOnInit(): void {
    this.profileActions.push({
      icon: 'po-icon-exit',
      label: 'Exit',
      type: 'danger',
      separator: true,
      url: 'login',
      action: () => this.logOut(),
    });

    this.loginSubject$ = this.loginService.loginSubject;
    this.subscription = this.loginSubject$?.subscribe(loginToken => {
      this.profile = { title: loginToken.name, subtitle: loginToken.email };
      this.customerService
        .getById(loginToken.tenantId)
        .subscribe(customer => {
          this.appname = `(${customer.nick}) ${customer.name}. Cidade: ${customer.city} - ${customer.state}. Inscrição: ${customer.registration}`;
        });
    });
  }

  ngOnDestroy(): void {
    this.subscription?.unsubscribe();
  }

  get title(): string {
    return this.homeService.homeData.title;
  }

  get icon(): string {
    return this.homeService.homeData.icon;
  }

  get routerUrl(): string {
    return this.homeService.homeData.routeUrl;
  }

  logOut(): void {
    this.loginService.logout();
  }
}
