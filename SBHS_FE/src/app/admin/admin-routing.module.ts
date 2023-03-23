import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AdminComponent } from './admin.component';
import { RequestAccountLandlordComponent } from './request-account-landlord/request-account-landlord.component';
import { AccountLandlordDetailComponent } from './request-account-landlord/account-landlord-detail/account-landlord-detail.component';
import { RequestHomestayComponent } from './request-homestay/request-homestay.component';
import { HomestayDetailComponent } from './request-homestay/homestay-detail/homestay-detail.component';
import { RequestBlocHomestayComponent } from './request-bloc-homestay/request-bloc-homestay.component';

const routes: Routes = [
  {
    path: '',
    component: AdminComponent,
    children: [
      {
        path: 'RequestAccountLandlord',
        component: RequestAccountLandlordComponent,
      },
      {
        path:'RequestAccountLandlord',
        children:[
          {
            path: 'AccountLandlordDetail',
            component: AccountLandlordDetailComponent
          }
        ]
      },
      {
        path: 'Homestay',
        component: RequestHomestayComponent,
      },
      {
        path:'Homestay',
        children:[
          {
            path: 'HomestayDetail',
            component: HomestayDetailComponent
          }
        ]
      },
      {
        path: 'BlocHomestay',
        component: RequestBlocHomestayComponent,
      },
      // {
      //   path:'BlocHomestay',
      //   children:[
      //     {
      //       path: 'HomestayDetail',
      //       component: HomestayDetailComponent
      //     }
      //   ]
      // },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class AdminRoutingModule {}
