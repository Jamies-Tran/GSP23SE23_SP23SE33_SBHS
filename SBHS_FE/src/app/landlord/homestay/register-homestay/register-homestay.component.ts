import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { MatStepper } from '@angular/material/stepper';
import { ActivatedRoute, Router } from '@angular/router';
import { ServerHttpService } from 'src/app/services/homestay.service';

@Component({
  selector: 'app-register-homestay',
  templateUrl: './register-homestay.component.html',
  styleUrls: ['./register-homestay.component.scss'],
})
export class RegisterHomestayComponent implements OnInit {
  //
  constructor(
    private _formBuilder: FormBuilder,
    public dialog: MatDialog,
    private router: Router,
    private route: ActivatedRoute,
    private http: ServerHttpService
  ) {}

  // homestayName: string = '';
  // totalRoom: string = '';
  // address: string = '';
  // city: string = '';

  newServices: any[] = [];

  ngOnInit(): void {}

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
  informationForm() {
    // Lay value
    console.log(this.informationFormGroup.value);
    const formInformationFormGroupValue = this.informationFormGroup.controls;
    this.homestayName = formInformationFormGroupValue.homestayName.value!;
    this.address = formInformationFormGroupValue.address.value!;
    this.totalRoom = formInformationFormGroupValue.number.value!;
    localStorage.setItem('homestayName', this.homestayName);
    localStorage.setItem('address', this.address);
    localStorage.setItem('totalRoom', this.totalRoom);
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
    console.log(' this.newFacility.push', this.newFacility);
    console.log(this.facilityFormGroup.value);
    if (this.facilityFormGroup.value['tv'] === true) {
      this.homestayFacilities.push({ name: 'tv', quantity: '2' });
    }
    if (this.facilityFormGroup.value['wifi'] === true) {
      this.homestayFacilities.push({ name: 'wifi', quantity: '2' });
    }
    localStorage.setItem(
      'homestayFacilities',
      JSON.stringify(this.homestayFacilities)
    );
  }
  enableInputTv() {
    if (this.facilityFormGroup.controls.tv.value === true) {
      this.facilityFormGroup.controls.tvAmount.enable();
    } else {
      this.facilityFormGroup.controls.tvAmount.disable();
    }
  }
  enableInputWifi() {
    if (this.facilityFormGroup.controls.wifi.value === true) {
      this.facilityFormGroup.controls.wifiAmount.enable();
    } else {
      this.facilityFormGroup.controls.wifiAmount.disable();
    }
  }
  // New Facility

  newFacility: any[] = [];

  addFacility() {
    this.newFacility.push({ name: '', status: false });
    console.log('values', this.newFacility);
    console.log('size', this.newFacility.length);
  }

  removeFacility(i: any) {
    this.newFacility.splice(i, 1);
    console.log('delete', this.newFacility.length + i);
  }

  // house rule
  houseRuleFormGroup = this._formBuilder.group({
    smoking: false,
    pet: false,
    checkIn: [''],
    checkOut: [''],
  });

  houseRuleForm() {
    console.log(this.houseRuleFormGroup.value);
    console.log(this.serviceFormGroup.value);

    this.serviceForm();
  }

  // Service
  serviceFormGroup = this._formBuilder.group({
    breakfast: false,
    breakfastPrice: [{ value: '', disabled: true }],
    swimming: false,
    swimmingPrice: [{ value: '', disabled: true }],
  });

  serviceForm() {
    console.log(this.serviceFormGroup.value);
    console.log(this.newService);
    let homestayServices: any = [];
    if (this.serviceFormGroup.value['breakfast'] === true) {
      // homestayServices.push({name: "Breakfast",price: this.serviceFormGroup.value["breakfastPrice"]["value"]})
      console.log(this.serviceFormGroup.value['breakfastPrice']);
    }
    this.router.navigate(['/Landlord/Homestay/Category/Overview'], {
      relativeTo: this.route,
    });
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
  public homestayImages: string[] = [];

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
      console.log('file lenght slice', this.homestayLicenseFiles.length);
      console.log('file array', this.homestayLicenseFiles);
      console.log('file index', this.homestayLicenseFiles.indexOf(files));
    }
    if (
      this.homestayImageFiles.length >= 1 &&
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
  public price = '';

  // register submit
  result: string = '';
  register() {}
}
