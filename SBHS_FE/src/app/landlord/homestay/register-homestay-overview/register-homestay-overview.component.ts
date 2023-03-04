import { Component, OnInit } from '@angular/core';
import { ServerHttpService } from 'src/app/services/homestay.service';
import { RegisterHomestayPriceComponent } from '../register-homestay-price/register-homestay-price.component';
import { RegisterHomestayComponent } from '../register-homestay/register-homestay.component';

@Component({
  selector: 'app-register-homestay-overview',
  templateUrl: './register-homestay-overview.component.html',
  styleUrls: ['./register-homestay-overview.component.scss']
})
export class RegisterHomestayOverviewComponent implements OnInit{
 ngOnInit(): void {
console.log(this.getHomestayinfo);
 }
  constructor(private http: ServerHttpService,public getHomestayinfo : RegisterHomestayComponent) {}
 result : string =""
  register(){
    let price = "123";

    let address =this.getHomestayinfo.address;
    let totalRoom ="";
    let city =""
    console.log(this.getHomestayinfo.homestayName)
    let homestayFacilities: Array<{name:string,quantity:string}> =[];
    homestayFacilities.push({name:'123',quantity:'1'});
    let homestayImages: Array<{imageUrl:string}>=[];
    homestayImages.push({imageUrl:"123"})
    let homestayServices: Array<{name: string,price: string, status:string}> =[];
    homestayServices.push({name:"breakfast",price:"123123",status:"true"})

    this.http.registerHomestay(this.getHomestayinfo.homestayName,address,totalRoom,city,homestayImages,homestayServices,homestayFacilities,price).subscribe((data) =>{
      console.log(data);
      this.result = "Register Homestay Success"
    },(error =>{
      this.result = "Register Homestay Fail!!!"
    }))
  }

}
