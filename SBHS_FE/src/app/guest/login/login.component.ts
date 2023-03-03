import { Component } from '@angular/core';
import {
  FormControl,
  FormGroupDirective,
  NgForm,
  Validators,
} from '@angular/forms';
import { ErrorStateMatcher } from '@angular/material/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ImageService } from 'src/app/services/image.service';
import { ServerHttpService } from 'src/app/services/login.service';
import { SocialAuthService } from '@abacritt/angularx-social-login';
@Component({
  selector: 'app-login-landlord',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginLandlordComponent {
  constructor(
    private http: ServerHttpService,
    private router: Router,
    private route: ActivatedRoute,
    private image: ImageService,
    private authService: SocialAuthService
  ) {}

  flag = 'false';
  user: any;
  loggedIn: any;

  async ngOnInit(): Promise<void> {
    if (localStorage.getItem('registerSuccess') == 'true') {
      this.flag = 'true';
    }

    // logo
    this.logoImageUrl = await this.image.getImage('logo/logo-3.png');
    console.log(this.logoImageUrl);

    // Image
    this.loginRegisterImageUrl = await this.image.getImage(
      'homepage/login-register.jpg'
    );
    console.log(this.loginRegisterImageUrl);

    // Login with gmail
    this.authService.authState.subscribe((user) => {
      this.user = user;
      this.loggedIn = user != null;
      console.log(this.user);
      console.log(this.user.name);
      console.log(this.user.email);
    });
  }
  hide = true;
  passwordFormControl = new FormControl('', [Validators.required]);
  usernameFormControl = new FormControl('', [Validators.required]);
  matcher = new MyErrorStateMatcher();

  public getProfile() {
    this.flag = 'false';
    this.http
      .login(
        this.usernameFormControl.value + '',
        this.passwordFormControl.value + ''
      )
      .subscribe((data) => {
        localStorage.setItem('userToken', data['token']);
        localStorage.setItem('username', data['username']);
        localStorage.setItem('role', data['roles']);
        console.log(data);
        if (data['roles'][0] === 'LANDLORD') {
          this.router.navigate(['/Landlord'], {
            relativeTo: this.route,
          });
        } else if (data['roles'][0] === 'ADMIN') {
          this.router.navigate(['/Admin'], {
            relativeTo: this.route,
          });
        } else this.router.navigate([''], {
          relativeTo: this.route,
        });
      });
  }

  // Image Url
  public loginRegisterImageUrl = '';
  public logoImageUrl = '';
}

/** Error when invalid control is dirty, touched, or submitted. */
export class MyErrorStateMatcher implements ErrorStateMatcher {
  isErrorState(
    control: FormControl | null,
    form: FormGroupDirective | NgForm | null
  ): boolean {
    const isSubmitted = form && form.submitted;
    return !!(
      control &&
      control.invalid &&
      (control.dirty || control.touched || isSubmitted)
    );
  }
}
