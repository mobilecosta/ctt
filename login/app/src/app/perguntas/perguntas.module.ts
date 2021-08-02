import { NgModule } from '@angular/core';
import { CardCountModule } from './../generic/card-count/card-count.module';
//import { PerguntasComponent } from './perguntas.component';
//import { HomeRoutingModule } from './home-routing.module';
import { SharedModule } from './../shared/shared.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';


@NgModule({
  imports: [
    SharedModule,
    CardCountModule,
 //   HomeRoutingModule,
    FormsModule,
    ReactiveFormsModule
  ],
  declarations: [
  //  PerguntasComponent
 //   HomeDashboardComponent
  ],
  providers: []
})
export class HomeModule { }
