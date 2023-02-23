// Component
import { HomestayComponent } from './homestay/homestay.component';
import { LandlordComponent } from './landlord.component';

// Module
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatButtonToggleModule } from '@angular/material/button-toggle';
import { MatMenuModule } from '@angular/material/menu';
import { MatIconModule } from '@angular/material/icon';
import { MatRippleModule } from '@angular/material/core';
import { MatDialogModule } from '@angular/material/dialog';
import { matSelectAnimations, MatSelectModule } from '@angular/material/select';
import { MatPaginatedTabHeader, MatTabsModule } from '@angular/material/tabs';
import { NgxPaginationModule } from 'ngx-pagination';
import { MatButtonModule } from '@angular/material/button';
import { LandlordRoutingModule } from './landlord-routing.module';
import { CategoryHomestayComponent } from './homestay/category-homestay/category-homestay.component';
import { RegisterHomestayComponent } from './homestay/register-homestay/register-homestay.component';
import { RegisterBlocHomestayComponent } from './homestay/register-bloc-homestay/register-bloc-homestay.component';

@NgModule({
  declarations: [HomestayComponent, LandlordComponent, CategoryHomestayComponent, RegisterHomestayComponent, RegisterBlocHomestayComponent],
  imports: [
    CommonModule,
    LandlordRoutingModule,
    MatIconModule,
    MatButtonToggleModule,
    MatMenuModule,
    MatRippleModule,
    MatDialogModule,
    MatSelectModule,
    MatTabsModule,
    NgxPaginationModule,
    MatButtonModule,
  ],
})
export class LandlordModule {}
