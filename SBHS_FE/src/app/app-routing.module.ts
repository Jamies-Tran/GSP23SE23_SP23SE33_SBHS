import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginAdminComponent } from './admin/login-admin/login-admin.component';
import { LoginLandlordComponent } from './landlord/login-landlord/login-landlord.component';
import { RegisterComponent } from './landlord/register/register.component';
import { ForgotPassComponent } from './forgot-pass/forgot-pass.component';
import { WelcomePageComponent } from './welcome-page/welcome-page.component';
import { AdminComponent } from './admin/admin.component';


const routes: Routes = [
   { path: 'Homepage', component: WelcomePageComponent },
  { path: 'Landlord', component: LoginLandlordComponent },
  { path: 'Register' , component: RegisterComponent},
  { path: 'ForgotPassword' , component: ForgotPassComponent},
  {path: 'Admin', component: AdminComponent},
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
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
