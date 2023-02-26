import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { ServerHttpService } from 'src/app/services/homestay.service';
import { RegisterHomestayPriceComponent } from '../register-homestay-price/register-homestay-price.component';

@Component({
  selector: 'app-register-homestay',
  templateUrl: './register-homestay.component.html',
  styleUrls: ['./register-homestay.component.scss'],
})
export class RegisterHomestayComponent implements OnInit {
  //
  constructor(private _formBuilder: FormBuilder,  public dialog: MatDialog) {}

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
    city: ['', Validators.required],
  });
  formInformationFormGroupValue = this.informationFormGroup.controls;
  homestayName = this.formInformationFormGroupValue.homestayName.value!;
  address = this.formInformationFormGroupValue.address.value!;
  number = this.formInformationFormGroupValue.number.value!;
  city = this.formInformationFormGroupValue.city.value!;
  informationForm() {
    // Lay value
    const formInformationFormGroupValue = this.informationFormGroup.controls;
    console.log(this.informationFormGroup.value);
  }

  // Facility
  facilityFormGroup = this._formBuilder.group({
    tv: false,
    wifi: false,
  });

  facilityForm() {
    console.log(' this.newFacility.push', this.newFacility);
    console.log(this.facilityFormGroup.value);
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
    this.serviceForm();
  }

  // Service
  serviceFormGroup = this._formBuilder.group({
    breakfast: false,
    breakfastPrice: [{ value: '', disabled: true }],
    swimming: false,
    swimmingPrice: [{ value: '', disabled: true }],
  })

  serviceForm(){
    console.log(this.serviceFormGroup.value);
    console.log(this.newService);
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
    this.newService.push({ name: '',price: '', status: false });
    console.log('values', this.newService);
    console.log('size', this.newService.length);
  }

  removeService(i: any) {
    this.newService.splice(i, 1);
    console.log('delete', this.newService.length + i);
  }


}
