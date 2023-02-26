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
import { MatStepperModule } from '@angular/material/stepper';
import {
  matFormFieldAnimations,
  MatFormFieldModule,
} from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MdbValidationModule } from 'mdb-angular-ui-kit/validation';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { MdbFormsModule } from 'mdb-angular-ui-kit/forms';
import { MatCheckboxModule } from '@angular/material/checkbox';


@NgModule({
  declarations: [
    HomestayComponent,
    LandlordComponent,
    CategoryHomestayComponent,
    RegisterHomestayComponent,
    RegisterBlocHomestayComponent,
  ],
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
    MatStepperModule,
    MatFormFieldModule,
    MatInputModule,
    MdbValidationModule,
    ReactiveFormsModule,
    FormsModule,
    MdbFormsModule,
    MatCheckboxModule
  ],
})
export class LandlordModule {}
