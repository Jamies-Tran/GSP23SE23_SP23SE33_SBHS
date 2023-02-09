import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginAdminComponent } from './admin/login-admin/login-admin.component';
import { LoginPasssengerComponent } from './passenger/login-passsenger/login-passsenger.component';
import { LoginLandlordComponent } from './landlord/login-landlord/login-landlord.component';
import { RegisterComponent } from './landlord/register/register.component';
import { ForgotPassComponent } from './forgot-pass/forgot-pass.component';

const routes: Routes = [
  { path: 'Admin', component: LoginAdminComponent },
  { path: 'Homepage', component: LoginPasssengerComponent },
  { path: 'Landlord', component: LoginLandlordComponent },
  { path: 'Register' , component: RegisterComponent},
  { path: 'ForgotPassword' , component: ForgotPassComponent},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
