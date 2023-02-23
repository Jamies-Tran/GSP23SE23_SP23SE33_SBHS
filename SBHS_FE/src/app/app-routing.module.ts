import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginLandlordComponent } from './guest/login/login.component';
import { RegisterComponent } from './guest/register/register.component';
import { ForgotPassComponent } from './guest/forgot-pass/forgot-pass.component';
import { WelcomePageComponent } from './guest/welcome-page/welcome-page.component';
import { AdminComponent } from './admin/admin.component';
import { LandlordComponent } from './landlord/landlord.component';
import { LandlordModule } from './landlord/landlord.module';

const routes: Routes = [
  { path: '', component: WelcomePageComponent },
  { path: 'Homepage', component: WelcomePageComponent },
  { path: 'Login', component: LoginLandlordComponent },
  { path: 'Register', component: RegisterComponent },
  { path: 'ForgotPassword', component: ForgotPassComponent },
  { path: 'Admin', component: AdminComponent },
  {
    path: 'Admin',
    loadChildren: () =>
      import('./admin/admin.module').then((m) => m.AdminModule),
  },
  {
    path: 'Admin',
    loadChildren: () =>
      import('./admin/admin-routing.module').then((m) => m.AdminRoutingModule),
  },
  { path: 'Landlord', component: LandlordComponent },
  {
    path: 'Landlord',
    loadChildren: () =>
      import('./landlord/landlord.module').then((m) => m.LandlordModule),
  },
  {
    path: 'Landlord',
    loadChildren: () =>
      import('./landlord/landlord-routing.module').then((m) => m.LandlordRoutingModule),
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
