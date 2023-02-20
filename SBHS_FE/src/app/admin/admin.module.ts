import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatButtonToggleModule } from '@angular/material/button-toggle';
import { MatMenuModule } from '@angular/material/menu';
import { AdminRoutingModule } from './admin-routing.module';

import { MatIconModule } from '@angular/material/icon';
import { MatRippleModule } from '@angular/material/core';
import { AdminComponent } from './admin.component';
import { RequestAccountLandlordComponent } from './request-account-landlord/request-account-landlord.component';
import { MatDialogModule } from '@angular/material/dialog';
import { matSelectAnimations, MatSelectModule } from '@angular/material/select';
import { MatPaginatedTabHeader, MatTabsModule } from '@angular/material/tabs';
import { NgxPaginationModule } from 'ngx-pagination';
import { AccountLandlordDetailComponent } from './request-account-landlord/account-landlord-detail/account-landlord-detail.component';
import { MatButtonModule } from '@angular/material/button';


@NgModule({
  declarations: [AdminComponent, RequestAccountLandlordComponent, AccountLandlordDetailComponent],
  imports: [
    CommonModule,
    AdminRoutingModule,
    MatIconModule,
    MatButtonToggleModule,
    MatMenuModule,
    MatRippleModule,
    MatDialogModule,
    MatSelectModule,
    MatTabsModule,
    NgxPaginationModule,
    MatButtonModule
  ],
})
export class AdminModule {}
