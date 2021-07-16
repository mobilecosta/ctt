import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { PoI18nConfig, PoI18nModule } from '@po-ui/ng-components';

import { AppComponent } from './app.component';
import { HeaderComponent } from './layout/header/header.component';
import { FooterComponent } from './layout/footer/footer.component';
import { AppRoutingModule } from './app-routing.module';
import { LoginComponent } from '@app/security/login/login.component';
import { HomeComponent } from './layout/home/home.component';
import { AccountComponent } from './layout/account/account.component';
import { TokenProviderInterceptor } from '@app/security/interceptors/token-provider.interceptor';
import { SharedModule } from '@shared/shared.module';
import { ListComponent } from './list/list.component';
import { HttpClientModule } from '@angular/common/http';
@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    FooterComponent,
    LoginComponent,
    HomeComponent,
    AccountComponent,
      ListComponent
   ],
  imports: [
    BrowserModule,
    SharedModule,
    AppRoutingModule,
    HttpClientModule
  ],
  providers: [
    {
      provide: HTTP_INTERCEPTORS,
      useClass: TokenProviderInterceptor,
      multi: true,
    },
  ],
  bootstrap: [AppComponent],
})
export class AppModule {}
