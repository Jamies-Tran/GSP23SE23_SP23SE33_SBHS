import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomestayComponent } from './homestay/homestay.component';
import { LandlordComponent } from './landlord.component';

import { RegisterBlocHomestayComponent } from './homestay/register-bloc-homestay/register-bloc-homestay.component';
import { RegisterHomestayComponent } from './homestay/register-homestay/register-homestay.component';
import { CategoryHomestayComponent } from './homestay/category-homestay/category-homestay.component';
import { ProfileComponent } from '../profile/profile.component';
import { AuthGuard } from '../auth.guard';
import { HomestayDetailComponent } from './homestay/homestay-detail/homestay-detail.component';
import { BlocHomestayDetailComponent } from './homestay/bloc-homestay-detail/bloc-homestay-detail.component';
import { BlocHomestayComponent } from './bloc-homestay/bloc-homestay.component';
import { BookingComponent } from './booking/booking.component';


const routes: Routes = [
  {
    path: '',
    component: LandlordComponent,
    canActivateChild: [AuthGuard],
    children: [
      {
        path: 'Homestay',
        component: HomestayComponent,
      },
      {
        path: 'Homestay',
        children: [
          {
            path: 'Category',
            component: CategoryHomestayComponent,
          },
          {
            path: 'Category',
            children: [
              {
                path: 'RegisterHomestay',
                component: RegisterHomestayComponent,
              },
              {
                path: 'RegisterBlocHomestay',
                component: RegisterBlocHomestayComponent,
              },
            ],
          },
          {
            path: 'HomestayDetail',
            component: HomestayDetailComponent,
          },
        ],
      },
      {
        path: 'Profile',
        component: ProfileComponent,
      },
      {
        path: 'BlockHomestay',
        component: BlocHomestayComponent,
      },
      {
        path: 'BlockHomestay',
        children: [
          {
            path: 'BlockHomestayDetail',
            component: BlocHomestayDetailComponent,
          },
        ],
      },
      {
        path: 'Booking',
        component: BookingComponent,
      },

    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class LandlordRoutingModule {}
