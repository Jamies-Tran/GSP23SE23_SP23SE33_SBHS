import { DatePipe } from '@angular/common';
import { Component, OnInit, AfterViewInit, ViewChild } from '@angular/core';
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
import { Observable } from 'rxjs';
import {map, startWith} from 'rxjs/operators';
import { MatAutocompleteTrigger } from '@angular/material/autocomplete';
import { MatFormField } from '@angular/material/form-field';

// import { Address, AddressPrediction, predictions2 } from './register.component';
import { MatDialog } from '@angular/material/dialog';
import { MessageComponent } from '../../pop-up/message/message.component';
import { SuccessComponent } from '../../pop-up/success/success.component';
@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss'],
})
export class RegisterComponent implements OnInit , AfterViewInit{
  constructor(
    private http: ServerHttpService,
    private router: Router,
    private route: ActivatedRoute,
    private storage: AngularFireStorage,
    private image: ImageService,
    public datepipe: DatePipe,
    public dialog: MatDialog,
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
  dobFormControl = new FormControl('2023/1/1', [Validators.required]);
  phoneFormControl = new FormControl('', [Validators.required]);
  gender = 'Male';
  matcher = new MyErrorStateMatcher();
  email = this.emailFormControl.value +"";
  validMail: boolean = true;
  filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;

  public valid() {
    this.validMail = this.filter.test(this.emailFormControl.value+"");
    if (this.usernameFormControl.value == '') {
      return;
    } else if (this.addressFormControl.value == '') {
      return;
    } else if (this.dobFormControl.value == '') {
      return;
    } else if (this.idFormControl.value == '') {
      return;
    } else if (this.phoneFormControl.value == '') {
      return;
    }
     else if (this.passwordFormControl.value != this.confirmPasswordFormControl.value) {
      return;
    }else if(this.passwordFormControl.value == ''){
      return;
    }
    else if (this.validMail == false) {
      return;
    } else return true;
  }
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
    console.log(this.fontCitizenIDfiles)
    if (this.fontCitizenIDfiles.length >= 1) {
      this.showDiv.font = false;
    }


    for (this.file of this.fontCitizenIDfiles) {
      this.front=this.file.name;
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
    for (this.file of this.backCitizenIDfiles) {
      this.back=this.file.name;
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
  back : string ="";
  front : string = "";
  Result : string ="";
  date :string = this.dobFormControl.value!
  lastest_date :string =""
  message='';
  // public convertDOB(){
  //   let newDate = new Date(this.date);
  //   this.lastest_date = this.datepipe.transform(newDate,'yyyy-MM-dd')+""
  // }
  public register() {
   // this.convertDOB();
    //console.log(this.lastest_date);
    if (this.valid() == true) {
    this.http
      .registerLandlord(
        this.addressFormControl.value + '',
        "1999-25-12",
        this.emailFormControl.value + '',
        this.gender,
        this.idFormControl.value + '',
        this.passwordFormControl.value + '',
        this.phoneFormControl.value + '',
        this.usernameFormControl.value + '',
        this.back,
        this.front
      )
      .subscribe((data) => {
        for(this.file of this.fontCitizenIDfiles ){
          const path = 'landlord/citizenIdentification/' + this.file.name;
          const fileRef = this.storage.ref(path);
          this.storage.upload(path, this.file);
        }
        for(this.file of this.backCitizenIDfiles ){
          const path = 'landlord/citizenIdentification/' + this.file.name;
          const fileRef = this.storage.ref(path);
          this.storage.upload(path, this.file);
        }

        localStorage.setItem('message', 'Register Success');
        localStorage.setItem('registerSuccess', 'true');
        this.message = 'Register Success';
        this.openDialogSuccess();
        this.router.navigate(['/Login'], { relativeTo: this.route });


      },error =>{
        this.Result = "Check your information!!!!"
        console.log(error.message);
        this.message = error.message;
        this.openDialogMessage();
      });
    } else console.log("register fail")
  }

  openDialogMessage() {
    this.dialog.open(MessageComponent, {
      data: this.message,
    });
  }
  openDialogSuccess() {
    const timeout = 3000;
    const dialogRef = this.dialog.open(SuccessComponent, {
      data: this.message,
    });
    dialogRef.afterOpened().subscribe(_ => {
      setTimeout(() => {
         dialogRef.close();
         location.reload();
      }, timeout)
    })
  }

  // auto complete
  // options :Address[] = [{value: 'Mary'}, {value: 'Shelley'}, {value: 'Mady'}];
  // filteredOptions!: Observable<Address[]>;

  // displayFn(address: Address): string {
  //   return address && address.value ? address.value : '';
  // }

  // private _filter(value: string): Address[] {
  //   const filterValue = value.toLowerCase();

  //   return this.options.filter(option => option.value.toLowerCase().includes(filterValue));
  // }

  @ViewChild(MatAutocompleteTrigger) autocomplete!: MatAutocompleteTrigger;
  @ViewChild('formField') autoCompleteFormField!: MatFormField;
  ngAfterViewInit() {
    var observer = new IntersectionObserver(
      (entries) => {
        if (!entries[0].isIntersecting)
          console.log('Element is is not in screen');
        this.autocomplete.closePanel();
      },
      { threshold: [1] }
    );

    observer.observe(this.autoCompleteFormField._elementRef.nativeElement);
  }


  // autocomplete Prediction
  place :any;

  filteredOptions!: Observable<predictions2[]>;
  predictions:any;

  public getAutocomplete(event:any):void{
    type predictions = Array<{description:string}>;
    this.place = event.target.value;
    this.http.getAutoComplete(this.place).subscribe((data) =>{
      console.log(data);
      const predictions:predictions    = data['predictions'];
      this.predictions = predictions
      console.log(this.predictions);
    })
  }

  public dob = '';


}






//  predictions 2
export class predictions2{
  description!:string;
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
