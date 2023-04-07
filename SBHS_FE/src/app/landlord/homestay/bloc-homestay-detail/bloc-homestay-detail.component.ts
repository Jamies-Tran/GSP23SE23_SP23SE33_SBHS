import { Component } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { BlocHomestay } from 'src/app/models/bloc-homestay.model';
import { MessageComponent } from 'src/app/pop-up/message/message.component';
import { SuccessComponent } from 'src/app/pop-up/success/success.component';
import { HomestayService } from 'src/app/services/homestay.service';
import { ImageService } from 'src/app/services/image.service';

@Component({
  selector: 'app-bloc-homestay-detail',
  templateUrl: './bloc-homestay-detail.component.html',
  styleUrls: ['./bloc-homestay-detail.component.scss']
})
export class BlocHomestayDetailComponent {
  constructor(
    private http: HomestayService,
    private image: ImageService,
    public dialog: MatDialog
  ) {}
  ngOnInit(): void {
    this.name = sessionStorage.getItem('name') as string;
    this.getHomestay();
  }
  name!: string;
  message!: string;
  datas!: BlocHomestay;
  url!: any;
  urls: string[] = [];
  urls4: string[] = [];
  priceTax!: number;
  openDialogMessage() {
    this.dialog.open(MessageComponent, {
      data: this.message,
    });
  }
  openDialogSuccess() {
    this.dialog.open(SuccessComponent, {
      data: this.message,
    });
  }
  getHomestay() {
    try {
      this.http.getBlocHomestayDetailByName(this.name).subscribe({
        next: async (data:any) =>{
          if(data){
            const value = data;
            this.urls = [];
            this.urls4 = [];
            console.log('data' , data);
            this.datas = {
              name:value.name,
              address:value.address,
              businessLicense:value.businessLicense,
              status:value.status,
              totalAverageRating:value.totalAverageRating,
              homestayServices:value.homestayServices,
              homestays:value.homestays,
              homestayRules:value.homestayRules,
              ratings:value.ratings
            }
            console.log('datas' , this.datas);
            for(let homestay of this.datas.homestays){
              for(let url of homestay.homestayImages){
                await this.image
                .getImage(('homestay/' + url.imageUrl) as string)
                .then((url) => {
                  let urls = url as string;
                  this.urls.push(urls);
                });
              }

            }
            for (let i = 3; i < this.urls.length && i <= 6; i++) {
              this.urls4.push(this.urls[i]);
            }
            await this.image
              .getImage(('license/' + this.datas.businessLicense) as string)
              .then((url) => {
                let urls = url as string;
                this.datas.businessLicense = urls;
              });
            for(let i =0 ; i<this.datas.homestays.length ; i++){
              var priceToFixed = (this.datas.homestays[i].price * 0.95).toFixed();
              this.datas.homestays[i].id  = priceToFixed as unknown as number;
            }
          }
        },
        error: (error) => {
          this.message = error;
          this.openDialogMessage;
        },
      })
    } catch (error) {
      this.message = error as string;
      this.openDialogMessage();
      console.log(error);
    }
  }
}
