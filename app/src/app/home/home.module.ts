import { NgModule } from '@angular/core';
import { CardCountModule } from './../generic/card-count/card-count.module';
import { HomeComponent } from './home.component';
import { HomeRoutingModule } from './home-routing.module';
import { SharedModule } from './../shared/shared.module';
import { PoModule, PoDynamicModule, PoFieldModule, PoDividerModule } from '@po-ui/ng-components';


@NgModule({
  imports: [
    SharedModule,
    CardCountModule,
    HomeRoutingModule,
    PoDynamicModule, PoModule, PoFieldModule, PoDividerModule

  ],
  declarations: [
    HomeComponent
  ],
  providers: []
})
export class HomeModule { }
