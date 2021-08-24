import { NgModule } from '@angular/core';
import { PesquisaComponent } from './pesquisa.component';
import { PesquisaRoutingModule } from './pesquisa-routing.module';
import { PoModule, PoDynamicModule, PoButtonModule, PoFieldModule } from '@po-ui/ng-components';
import { FormsModule, ReactiveFormsModule } from "@angular/forms";



@NgModule({
  imports: [
    PesquisaRoutingModule,
    PoModule,
    PoDynamicModule,
    FormsModule, ReactiveFormsModule, PoButtonModule
    ],
  declarations: [
    PesquisaComponent
  ],
  providers: []
})
export class PesquisaModule { }
