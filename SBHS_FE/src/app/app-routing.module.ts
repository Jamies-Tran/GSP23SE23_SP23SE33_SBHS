import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginAdminComponent } from './admin/login-admin/login-admin.component';
import { LoginPasssengerComponent } from './passenger/login-passsenger/login-passsenger.component';
import { LoginLandlordComponent } from './landlord/login-landlord/login-landlord.component';

const routes: Routes = [
  { path: 'Admin', component: LoginAdminComponent },
  { path: 'Passenger', component: LoginPasssengerComponent },
  { path: 'Landlord', component: LoginLandlordComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
