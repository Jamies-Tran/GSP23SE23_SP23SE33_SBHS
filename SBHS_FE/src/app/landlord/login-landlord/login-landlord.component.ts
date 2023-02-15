import { Component } from '@angular/core';
import {FormControl, FormGroupDirective, NgForm, Validators} from '@angular/forms';
import {ErrorStateMatcher} from '@angular/material/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ImageService } from 'src/app/services/image.service';
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
    private route: ActivatedRoute,
    private image: ImageService,
  ) {}
  flag = 'false'
  async ngOnInit(): Promise<void> {
    if(localStorage.getItem("registerSucess") == 'true'){
      this.flag = "true"
    }

    this.loginRegisterImageUrl =await this.image.getImage('homepage/login-register.jpg' );
        console.log(this.loginRegisterImageUrl);
  }
  hide = true;
  passwordFormControl = new FormControl('', [Validators.required]);
  usernameFormControl = new FormControl('', [Validators.required]);
  matcher = new MyErrorStateMatcher();

  public getProfile() {
    this.flag = "false"
    this.http.login(this.usernameFormControl.value +"",this.passwordFormControl.value +"").subscribe(
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

    // Right Image Url
    public loginRegisterImageUrl = '';

}


/** Error when invalid control is dirty, touched, or submitted. */
export class MyErrorStateMatcher implements ErrorStateMatcher {
  isErrorState(control: FormControl | null, form: FormGroupDirective | NgForm | null): boolean {
    const isSubmitted = form && form.submitted;
    return !!(control && control.invalid && (control.dirty || control.touched || isSubmitted));
  }
}
