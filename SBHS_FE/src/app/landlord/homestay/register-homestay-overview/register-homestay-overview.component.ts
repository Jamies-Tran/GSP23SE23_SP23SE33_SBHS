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
 }
  constructor(private http: ServerHttpService) {}
 result : string =""
  register(){
    let price = "123";

    let address ="";
    let totalRoom ="";
    let city =""
    console.log(localStorage.getItem("homestayFacilities"))
    let homestayFacilities: any =localStorage.getItem("homestayFacilities");
    let homestayImages: Array<{imageUrl:string}>=[];
    homestayImages.push({imageUrl:"123"})
    let homestayServices: Array<{name: string,price: string, status:string}> =[];
    homestayServices.push({name:"breakfast",price:"123123",status:"true"})

    this.http.registerHomestay(localStorage.getItem("homestayName")+"",address,totalRoom,city,homestayImages,homestayServices,homestayFacilities,price).subscribe((data) =>{
      console.log(data);
      this.result = "Register Homestay Success"
    },(error =>{
      this.result = "Register Homestay Fail!!!"
    }))
  }
  
}
