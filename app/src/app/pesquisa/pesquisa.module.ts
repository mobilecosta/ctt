import { NgModule } from '@angular/core';
import { PesquisaComponent } from './pesquisa.component';
import { PesquisaRoutingModule } from './pesquisa-routing.module';
import { PoModule, PoDynamicModule, PoButtonModule, PoInfoModule } from '@po-ui/ng-components';
import { FormsModule, ReactiveFormsModule } from "@angular/forms";



@NgModule({
  imports: [
    PesquisaRoutingModule,
    PoModule,
    PoDynamicModule,
    FormsModule, ReactiveFormsModule, PoButtonModule, PoInfoModule
    ],
  declarations: [
    PesquisaComponent
  ],
  providers: []
})
export class PesquisaModule { }
