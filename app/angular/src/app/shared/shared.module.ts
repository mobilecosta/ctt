import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule } from '@angular/forms';
import {
  PoModule,
  PoComponentsModule,
  PoMenuModule,
  PoTableModule,
  PoFieldModule,
  PoBreadcrumbModule
} from '@po-ui/ng-components';

@NgModule({
  declarations: [],
  imports: [
    CommonModule,
    ReactiveFormsModule,
    PoModule,
    PoComponentsModule,
    PoMenuModule,
    PoTableModule,
    PoFieldModule,
    PoBreadcrumbModule,
  ],
  exports: [
    CommonModule,
    ReactiveFormsModule,
    PoModule,
    PoComponentsModule,
    PoMenuModule,
    PoTableModule,
    PoFieldModule,
    PoBreadcrumbModule,
  ],
})
export class SharedModule {}
