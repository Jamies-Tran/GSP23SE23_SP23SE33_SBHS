import { Component, OnInit, ViewChild, AfterViewInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { MatStepper } from '@angular/material/stepper';
import { ActivatedRoute, Router } from '@angular/router';
import { ServerHttpService } from 'src/app/services/homestay.service';
import { AngularFireStorage } from '@angular/fire/compat/storage';
import { Observable } from 'rxjs';
import { map, startWith } from 'rxjs/operators';
import { MatAutocompleteTrigger } from '@angular/material/autocomplete';
import { MatFormField } from '@angular/material/form-field';

@Component({
  selector: 'app-register-homestay',
  templateUrl: './register-homestay.component.html',
  styleUrls: ['./register-homestay.component.scss'],
})
export class RegisterHomestayComponent implements OnInit, AfterViewInit {
  //
  constructor(
    private _formBuilder: FormBuilder,
    public dialog: MatDialog,
    private router: Router,
    private route: ActivatedRoute,
    private http: ServerHttpService,
    private storage: AngularFireStorage
  ) { }

  // homestayName: string = '';
  // totalRoom: string = '';
  // address: string = '';
  // city: string = '';

  ngOnInit(): void { }

  // information

  informationFormGroup = this._formBuilder.group({
    homestayName: ['', Validators.required],
    address: ['', Validators.required],
    number: ['', Validators.required],
    homestayLicense: [false, Validators.requiredTrue],
  });
  homestayName: string = '';
  address: string = '';
  totalRoom: string = '';
  isHomestayLicense: boolean = false;
  validateInformationForm(){

  }
  informationForm() {
    // Lay value
    this.flag = false

    console.log(this.informationFormGroup.value);
    const formInformationFormGroupValue = this.informationFormGroup.controls;
    this.homestayName = formInformationFormGroupValue.homestayName.value!;
    this.address = formInformationFormGroupValue.address.value!;
    this.totalRoom = formInformationFormGroupValue.number.value!;
    this.isHomestayLicense = formInformationFormGroupValue.homestayLicense.value!;
    if (this.homestayName === "") {
      this.result = "Please enter homestay's name"
      return
    }
    else if (this.address === "") {
      this.result = "Please enter address"
      console.log(this.address)
      return
    }
    else if (this.totalRoom === "") {
      this.result = "Please enter total room"
      return
    }
    else if (!this.isHomestayLicense) {
      this.result = "Please upload at a photo of your Homestay License" + this.isHomestayLicense;
      return
    }
    else {
      this.result ='';
      this.flag = true;
      this.stepper.selectedIndex = 1;
    }
  }

  // Facility
  facilityFormGroup = this._formBuilder.group({
    tv: false,
    tvAmount: [{ value: '', disabled: true }],
    wifi: false,
    wifiAmount: [{ value: '', disabled: true }],
  });
  homestayFacilities: Array<{ name: string; quantity: string }> = [];
  facilityForm() {
    console.log(this.facilityFormGroup.value);
    // console.log(this.homestayFacilities)
    this.stepper.selectedIndex = 2;
  }
  enableInputTv() {
    if (this.facilityFormGroup.controls.tv.value === true) {
      this.facilityFormGroup.controls.tvAmount.enable();
      this.facilityFormGroup.controls.tvAmount.clearValidators();
    } else {
      this.facilityFormGroup.controls.tvAmount.disable();
    }
  }
  enableInputWifi() {
    if (this.facilityFormGroup.controls.wifi.value === true) {
      this.facilityFormGroup.controls.wifiAmount.enable();
      this.facilityFormGroup.controls.wifiAmount.clearValidators();
    } else {
      this.facilityFormGroup.controls.wifiAmount.disable();
    }
  }
  // New Facility

  newFacility: any[] = [];

  addFacility() {
    this.newFacility.push({ name: '', status: false });
    console.log(this.newFacility);
    // console.log(this.newFacility[this.newFacility.length-1]);
    // if(this.newFacility[this.newFacility.length-1]["status"] === true){
    //   this.homestayFacilities.push({name: this.newFacility[this.newFacility.length-1]["name"],quantity: this.newFacility[this.newFacility.length-1]["price"]})
    // }
    // console.log(this.homestayFacilities)
  }

  removeFacility(i: any) {
    this.newFacility.splice(i, 1);
    // console.log(this.newFacility[i]);
    // if(this.newFacility[i]["status"] === false){
    //   this.homestayFacilities.splice(i+2,1)
    // }
    // this.homestayFacilities.splice(i+2,1)
    // console.log(this.homestayFacilities)
  }

  // house rule
  houseRuleFormGroup = this._formBuilder.group({
    smoking: false,
    pet: false,
    checkIn: [''],
    checkOut: [''],
  });
  homestayRules: any[] = [];
  houseRuleForm() {
    console.log(this.houseRuleFormGroup.value);
    if (this.houseRuleFormGroup.value["pet"] === true) {
      this.homestayRules.push({ description: "non pet" })
    }
    if (this.houseRuleFormGroup.value["smoking"] === true) {
      this.homestayRules.push({ description: "non smoking" })
    }
  }

  // Service
  serviceFormGroup = this._formBuilder.group({
    breakfast: false,
    breakfastPrice: [{ value: '', disabled: true }],
    swimming: false,
    swimmingPrice: [{ value: '', disabled: true }],
  });
  homestayServices: any[] = [];
  serviceForm() {
    console.log(this.serviceFormGroup.value);
    console.log(this.newService);
    if (this.serviceFormGroup.value['breakfast'] === true) {
      this.homestayServices.push({ name: "Breakfast", price: this.serviceFormGroup.value['breakfastPrice'] })
    }
    if (this.serviceFormGroup.value['swimming'] === true) {
      this.homestayServices.push({ name: "Swimming", price: this.serviceFormGroup.value['swimmingPrice'] })
    }
  }

  enableInputBreakfast() {
    if (this.serviceFormGroup.controls.breakfast.value === true) {
      this.serviceFormGroup.controls.breakfastPrice.enable();
    } else {
      this.serviceFormGroup.controls.breakfastPrice.disable();
    }
  }
  enableInputSwimming() {
    if (this.serviceFormGroup.controls.swimming.value === true) {
      this.serviceFormGroup.controls.swimmingPrice.enable();
    } else {
      this.serviceFormGroup.controls.swimmingPrice.disable();
    }
  }

  // New Service

  newService: any[] = [];

  addService() {
    this.newService.push({ name: '', price: '', status: false });
    console.log('values', this.newService);
    console.log('size', this.newService.length);
  }

  @ViewChild('stepper') stepper!: MatStepper;
  removeService(i: any) {
    this.newService.splice(i, 1);
    console.log('delete', this.newService.length + i);
  }

  step1() {
    this.stepper.selectedIndex = 0;
  }
  step5() {
    this.stepper.selectedIndex = 4;
  }
  step6() {
    this.stepper.selectedIndex = 5;
  }

  // Register Image
  file!: File;
  homestayLicenseFiles: File[] = [];
  homestayImageFiles: File[] = [];

  // image name file
  public homestayLicense!: string;
  public homestayImages: any[] = [];

  // lấy file hình
  onSelectHomestayLicense(files: any) {
    console.log('onselect: ', files);
    // set files
    this.homestayLicenseFiles.push(...files.addedFiles);
    console.log('file array', this.homestayLicenseFiles);
    console.log('file lenght', this.homestayLicenseFiles.length);

    if (this.homestayLicenseFiles.length > 1) {
      this.homestayLicenseFiles.splice(
        this.homestayLicenseFiles.indexOf(files),
        1
      );
    }
    if (
      this.homestayImageFiles.length >= 1 ||
      this.homestayLicenseFiles.length == 1
    ) {
      this.informationFormGroup.patchValue({ homestayLicense: true });
    } else {
      this.informationFormGroup.patchValue({ homestayLicense: false });
    }

  }

  // xóa file hình
  onRemoveHomestayLicense(event: File) {
    console.log(event);
    console.log('xoa index:', this.homestayLicenseFiles.indexOf(event));
    this.homestayLicenseFiles.splice(
      this.homestayLicenseFiles.indexOf(event),
      1
    );
    console.log('xoa file:', this.homestayLicenseFiles);
    if (
      this.homestayImageFiles.length >= 1 &&
      this.homestayLicenseFiles.length == 1
    ) {
      this.informationFormGroup.patchValue({ homestayLicense: true });
    } else {
      this.informationFormGroup.patchValue({ homestayLicense: false });
    }

  }

  // lấy file hình
  onSelectImageHomestay(files: any) {
    console.log('onselect: ', files);
    // set files
    this.homestayImageFiles.push(...files.addedFiles);

  }

  // xóa file hình
  onRemoveHomestayImage(event: File) {
    console.log(event);
    this.homestayImageFiles.splice(this.homestayImageFiles.indexOf(event), 1);
    console.log('xoa file:', this.homestayImageFiles);
  }

  // Price
  public price =0;
  public priceTax :any;
  calcPriceTax(event:any){
    var priceToFixed = (this.price * 0.05).toFixed();
    this.priceTax = priceToFixed ;
  }

  // register submit
  result: string = '';

  // autocomplete
  // autocomplete Prediction
  place: any;

  filteredOptions!: Observable<predictions[]>;
  predictions: any;

  public getAutocomplete(event: any): void {
    type predictions = Array<{ description: string }>;
    this.place = event.target.value;
    this.http.getAutoComplete(this.place).subscribe((data) => {
      console.log(data);
      const predictions: predictions = data['predictions'];
      this.predictions = predictions;
      console.log(this.predictions);
    });
  }
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
  // validate
  flag = false;
  // submit
  register() {
    console.log('register');
    // homestay Image
    for (this.file of this.homestayImageFiles) {
      const path =
        'homestay/' +
        this.informationFormGroup.controls.homestayName.value +
        ' ' +
        this.file.name;
      const fileRef = this.storage.ref(path);
      this.storage.upload(path, this.file);
      this.homestayImages.push({imageUrl: this.file.name});
    }

    // homestayLicenseFiles
    for (this.file of this.homestayLicenseFiles) {
      const path =
        'license/' +
        this.informationFormGroup.controls.homestayName.value +
        ' ' +
        this.file.name;
      const fileRef = this.storage.ref(path);
      this.storage.upload(path, this.file);
      this.homestayLicense = this.file.name;
    }
    console.log(this.homestayImages)

    if (this.flag === true) {
      this.http.registerHomestay(this.homestayName, this.address, this.totalRoom,
        this.homestayLicense, this.homestayImages, this.homestayServices, this.homestayFacilities, this.priceTax.toString(), this.homestayRules).subscribe((data => {
          this.result = "Register Homestay Success"
        }), error => {
          this.result = error
        })
    }
  }
}

export class predictions {
  description!: string;
}
