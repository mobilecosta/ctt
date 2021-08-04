import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PerguntasComponent } from './perguntas/perguntas.component';

const routes: Routes = [

  {path:'',redirectTo:'',pathMatch:'full'},

  {path:'perguntas', component: PerguntasComponent}
];


@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
