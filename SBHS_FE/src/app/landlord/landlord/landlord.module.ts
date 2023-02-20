import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { LandlordRoutingModule } from './landlord-routing.module';
import { HomestayComponent } from '../homestay/homestay.component';
import { LandlordComponent } from './landlord.component';


@NgModule({
  declarations: [
    HomestayComponent,
    LandlordComponent
  ],
  imports: [
    CommonModule,
    LandlordRoutingModule
  ]
})
export class LandlordModule { }
