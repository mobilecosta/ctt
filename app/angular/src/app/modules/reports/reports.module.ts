import { RouterModule } from '@angular/router';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ReportRoutingModule } from './report-routing.module';
import { ReportListComponent } from './report-list/report-list.component';
import { SharedModule } from '@shared/shared.module';

@NgModule({
  declarations: [ReportListComponent],
  imports: [SharedModule, ReportRoutingModule],
  exports: [RouterModule],
})
export class ReportsModule {}
