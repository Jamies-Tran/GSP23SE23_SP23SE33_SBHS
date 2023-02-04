// Module
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AppRoutingModule } from './app-routing.module';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatRadioModule } from '@angular/material/radio';
import { MatSelectModule } from '@angular/material/select';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { NgxDropzoneModule } from 'ngx-dropzone';
// Component
import { AppComponent } from './app.component';
import { LoginAdminComponent } from './admin/login-admin/login-admin.component';
import { LoginLandlordComponent } from './landlord/login-landlord/login-landlord.component';
import { LoginPasssengerComponent } from './passenger/login-passsenger/login-passsenger.component';
import { ReactiveFormsModule } from '@angular/forms';
import { RegisterComponent } from './landlord/register/register.component';
import { MatNativeDateModule } from '@angular/material/core';
import { ForgotPassComponent } from './forgot-pass/forgot-pass.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginAdminComponent,
    LoginLandlordComponent,
    LoginPasssengerComponent,
    RegisterComponent,
    ForgotPassComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MatFormFieldModule,
    MatInputModule,
    MatIconModule,
    MatButtonModule,
    ReactiveFormsModule,
    MatRadioModule,
    MatCheckboxModule,
    MatSelectModule,
    MatDatepickerModule,
    MatNativeDateModule,
    NgxDropzoneModule,

  ],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
