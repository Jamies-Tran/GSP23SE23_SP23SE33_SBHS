import { Component } from '@angular/core';
import {FormControl, FormGroupDirective, NgForm, Validators} from '@angular/forms';
import {ErrorStateMatcher} from '@angular/material/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ServerHttpService } from 'src/app/services/login.service';
@Component({
  selector: 'app-login-landlord',
  templateUrl: './login-landlord.component.html',
  styleUrls: ['./login-landlord.component.scss']
})
export class LoginLandlordComponent {
  constructor(
    private http: ServerHttpService,
    private router: Router,
    private route: ActivatedRoute
  ) {}
  hide = true;
  passwordFormControl = new FormControl('', [Validators.required]);
  usernameFormControl = new FormControl('', [Validators.required]);
  matcher = new MyErrorStateMatcher();
  username = this.usernameFormControl.value+"";
  password = "";

  public getProfile() {
    console.log(this.username)
    this.http.login(this.username,this.password).subscribe(
      (data) => {
        localStorage.setItem('userToken', data['token']);
        localStorage.setItem('username', data['username']);
        console.log(data)
        // if (data['roles'][0]['authority'] === 'ROLE_LANDLORD') {
        //   this.router.navigate(['/Landlord/Dashboard'], {
        //     relativeTo: this.route,
        //   });
        // } else
        //   this.router.navigate(['/Admin/Request'], { relativeTo: this.route });
      }
    );
  }
}


/** Error when invalid control is dirty, touched, or submitted. */
export class MyErrorStateMatcher implements ErrorStateMatcher {
  isErrorState(control: FormControl | null, form: FormGroupDirective | NgForm | null): boolean {
    const isSubmitted = form && form.submitted;
    return !!(control && control.invalid && (control.dirty || control.touched || isSubmitted));
  }
}
