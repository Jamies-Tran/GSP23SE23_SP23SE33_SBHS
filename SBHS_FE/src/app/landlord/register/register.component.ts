import { Component, OnInit } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/compat/storage';
import {
  FormControl,
  FormGroupDirective,
  NgForm,
  Validators,
} from '@angular/forms';
import { ErrorStateMatcher } from '@angular/material/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ServerHttpService } from 'src/app/services/register.service';
import { ImageService } from '../../services/image.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss'],
})
export class RegisterComponent {
  constructor(
    private http: ServerHttpService,
    private router: Router,
    private route: ActivatedRoute,
    private storage: AngularFireStorage,
    private image: ImageService
  ) {}
  hidePassword = true;
  hideConfirmPass = true;
  passwordFormControl = new FormControl('', [Validators.required]);
  confirmPasswordFormControl = new FormControl('', [Validators.required]);
  usernameFormControl = new FormControl('', [Validators.required]);
  emailFormControl = new FormControl('', [
    Validators.required,
    Validators.email,
  ]);
  addressFormControl = new FormControl('', [Validators.required]);
  idFormControl = new FormControl('', [Validators.required]);
  dobFormControl = new FormControl('', [Validators.required]);
  phoneFormControl = new FormControl('', [Validators.required]);
  gender = 'Male';
  matcher = new MyErrorStateMatcher();

  getEmailErrorMessage() {
    if (this.emailFormControl.hasError('required')) {
      return 'You must enter a <strong> value </strong>';
    }

    return this.emailFormControl.hasError('email')
      ? 'Not a valid <strong>email</strong>'
      : '';
  }

  // hide
  showDiv = {
    font: true,
    back: true,
  };

  // Right Image Url
  public loginRegisterImageUrl = '';
  public logoImageUrl = '';
  async ngOnInit(): Promise<void> {
    this.loginRegisterImageUrl = await this.image.getImage(
      'homepage/login-register.jpg'
    );
    console.log(this.loginRegisterImageUrl);

    // logo
    this.logoImageUrl = await this.image.getImage('logo/logo-3.png');
    console.log(this.logoImageUrl);
  }

  // File image
  fontCitizenIDfiles: File[] = [];
  backCitizenIDfiles: File[] = [];
  file!: File;

  onSelectFontCitizenID(files: any) {
    console.log(event);
    this.fontCitizenIDfiles.push(...files.addedFiles);
    if (this.fontCitizenIDfiles.length >= 1) {
      this.showDiv.font = false;
    }

    // test up imge firebase
    for (this.file of this.fontCitizenIDfiles) {
      const path = 'test/' + this.file.name;
      const fileRef = this.storage.ref(path);
      this.storage.upload(path, this.file);
    }
  }

  onRemoveFontCitizenID(event: File) {
    console.log(event);
    this.fontCitizenIDfiles.splice(this.fontCitizenIDfiles.indexOf(event), 1);
    console.log('files lenght: ', this.fontCitizenIDfiles.length);
    if (this.fontCitizenIDfiles.length >= 1) {
      this.showDiv.font = false;
    } else {
      this.showDiv.font = true;
    }
  }

  onSelectBackCitizenID(files: any) {
    console.log(event);
    this.backCitizenIDfiles.push(...files.addedFiles);
    if (this.backCitizenIDfiles.length >= 1) {
      this.showDiv.back = false;
    }
  }

  onRemoveBackCitizenID(event: File) {
    console.log(event);
    this.backCitizenIDfiles.splice(this.backCitizenIDfiles.indexOf(event), 1);
    console.log('files lenght: ', this.backCitizenIDfiles.length);
    if (this.backCitizenIDfiles.length >= 1) {
      this.showDiv.back = false;
    } else {
      this.showDiv.back = true;
    }
  }

  public register() {
    this.http
      .registerLandlord(
        this.addressFormControl.value + '',
        this.dobFormControl.value + '',
        this.emailFormControl.value + '',
        this.gender,
        this.idFormControl.value + '',
        this.passwordFormControl.value + '',
        this.phoneFormControl.value + '',
        this.usernameFormControl.value + ''
      )
      .subscribe((data) => {
        localStorage.setItem('registerSuccess', 'true');
        this.router.navigate(['/Landlord'], { relativeTo: this.route });
      });
  }
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
