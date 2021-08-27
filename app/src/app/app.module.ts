import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { PoNotificationModule } from '@po-ui/ng-components';

import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';
import { HomeModule } from './home/home.module';
import { LoginService } from './login/login.service';
import { SharedModule } from './shared/shared.module';
import { LoginModule } from './login/login.module';
import { AuthInterceptor } from './auth/auth-config.interceptor';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { PesquisaModule } from './pesquisa/pesquisa.module';
import { SuccessModule } from './success/success.module';



@NgModule({
  imports: [
    AppRoutingModule,
    BrowserModule,
    SharedModule,
    HomeModule,
    LoginModule,
    PesquisaModule,
    PoNotificationModule,
    SuccessModule
  ],
  declarations: [
    AppComponent
  ],
  providers: [
    LoginService,
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      multi: true
    }
],
  bootstrap: [AppComponent]
})
export class AppModule { }
