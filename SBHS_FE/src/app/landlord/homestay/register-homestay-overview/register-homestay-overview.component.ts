import { Component } from '@angular/core';
import { ServerHttpService } from 'src/app/services/homestay.service';
import { RegisterHomestayPriceComponent } from '../register-homestay-price/register-homestay-price.component';
import { RegisterHomestayComponent } from '../register-homestay/register-homestay.component';

@Component({
  selector: 'app-register-homestay-overview',
  templateUrl: './register-homestay-overview.component.html',
  styleUrls: ['./register-homestay-overview.component.scss']
})
export class RegisterHomestayOverviewComponent {
  constructor(private http: ServerHttpService) {}
  register(){
    let price = "123";
    let homestayName ="";
    let address ="";
    let totalRoom ="";
    let city =""
    let homestayFacilities: Array<{name:string,quantity:string}> =[];
    homestayFacilities.push({name:'123',quantity:'1'});
    let homestayImages: Array<{imageUrl:string}>=[];
    homestayImages.push({imageUrl:"123"})
    let homestayServices: Array<{name: string,price: string, status:string}> =[];
    homestayServices.push({name:"breakfast",price:"123123",status:"true"})
    this.http.registerHomestay(homestayName,address,totalRoom,city,homestayImages,homestayServices,homestayFacilities,price).subscribe((data) =>{
      console.log(data);
    })
  }
}
