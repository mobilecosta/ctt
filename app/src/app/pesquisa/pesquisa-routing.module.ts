import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { PesquisaComponent } from './pesquisa.component';

const pesquisaRoutes: Routes = [
  { path: ':curso', component: PesquisaComponent,
    children: [
    ] }
];

@NgModule({
  imports: [RouterModule.forChild(pesquisaRoutes)],
  exports: [RouterModule]
})
export class PesquisaRoutingModule { }
