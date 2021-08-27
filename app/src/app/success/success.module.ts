import { NgModule } from '@angular/core';
import { SuccessComponent } from './success.component';
import { SuccessRoutingModule } from './success-routing.module';
import { PoModule, PoDynamicModule, PoFieldModule, PoDividerModule } from '@po-ui/ng-components';





@NgModule({
  imports: [
    SuccessRoutingModule,
    PoDynamicModule, PoModule, PoFieldModule, PoDividerModule
  ],
  declarations: [
    SuccessComponent
  ],
  providers: []
})
export class SuccessModule { }
