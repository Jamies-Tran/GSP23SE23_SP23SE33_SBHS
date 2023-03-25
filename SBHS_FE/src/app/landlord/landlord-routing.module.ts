import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomestayComponent } from './homestay/homestay.component';
import { LandlordComponent } from './landlord.component';

import { RegisterBlocHomestayComponent } from './homestay/register-bloc-homestay/register-bloc-homestay.component';
import { RegisterHomestayComponent } from './homestay/register-homestay/register-homestay.component';
import { CategoryHomestayComponent } from './homestay/category-homestay/category-homestay.component';
import { ProfileComponent } from '../profile/profile.component';
import { AuthGuard } from '../auth.guard';


const routes: Routes = [
  {
    path: '',
    component: LandlordComponent,canActivateChild: [AuthGuard],
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
        ],
      },
      {
        path: 'Profile',
        component: ProfileComponent
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class LandlordRoutingModule {}
