import { RouterModule } from '@angular/router';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DashBoardRoutingModule } from './dash-board-routing.module';
import { DashBoardComponent } from './dash-board.component';
import { SharedModule } from '@shared/shared.module';

@NgModule({
  declarations: [DashBoardComponent],
  imports: [CommonModule, SharedModule, DashBoardRoutingModule],
  exports: [RouterModule],
})
export class DashBoardModule {}
