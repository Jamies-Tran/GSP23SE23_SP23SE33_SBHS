import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-register-homestay',
  templateUrl: './register-homestay.component.html',
  styleUrls: ['./register-homestay.component.scss'],
})
export class RegisterHomestayComponent implements OnInit {
  //
  constructor(private _formBuilder: FormBuilder,  public dialog: MatDialog,private router: Router,
    private route: ActivatedRoute) {}

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

  });
  homestayName : string ="";
  address : string ="";
  totalRoom : string ="";
  informationForm() {
    // Lay value

    const formInformationFormGroupValue = this.informationFormGroup.controls;
    this.homestayName = formInformationFormGroupValue.homestayName.value!;
    this.address = formInformationFormGroupValue.address.value!;
    this.totalRoom = formInformationFormGroupValue.number.value!;
    localStorage.setItem("homestayName",this.homestayName);
    localStorage.setItem("address",this.address);
    localStorage.setItem("totalRoom",this.totalRoom);
  }

  // Facility
  facilityFormGroup = this._formBuilder.group({
    tv: false,
    tvAmount:[{ value: '', disabled: true }],
    wifi: false,
    wifiAmount:[{ value: '', disabled: true }],
  });
  homestayFacilities: Array<{name:string,quantity:string}> = [];
  facilityForm() {
    console.log(' this.newFacility.push', this.newFacility);
    console.log(this.facilityFormGroup.value);
    if(this.facilityFormGroup.value["tv"] === true){
      this.homestayFacilities.push({name:"tv",quantity:"2"})
    }
    if(this.facilityFormGroup.value["wifi"] === true){
      this.homestayFacilities.push({name:"wifi",quantity:"2"})
    }
    localStorage.setItem("homestayFacilities",JSON.stringify(this.homestayFacilities))
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
  })

  serviceForm(){
    console.log(this.serviceFormGroup.value);
    console.log(this.newService);
    let homestayServices : any =[];
    if(this.serviceFormGroup.value["breakfast"] === true){
      // homestayServices.push({name: "Breakfast",price: this.serviceFormGroup.value["breakfastPrice"]["value"]})
      console.log(this.serviceFormGroup.value["breakfastPrice"])
    }
    this.router.navigate(['/Landlord/Homestay/Category/Overview'], {
      relativeTo: this.route})
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
