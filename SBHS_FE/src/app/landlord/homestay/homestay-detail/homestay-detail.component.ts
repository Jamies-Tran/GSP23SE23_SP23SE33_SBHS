import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Homestay } from 'src/app/models/homestay.model';
import { MessageComponent } from 'src/app/pop-up/message/message.component';
import { SuccessComponent } from 'src/app/pop-up/success/success.component';
import { HomestayService } from 'src/app/services/homestay.service';
import { ImageService } from 'src/app/services/image.service';

@Component({
  selector: 'app-homestay-detail',
  templateUrl: './homestay-detail.component.html',
  styleUrls: ['./homestay-detail.component.scss'],
})
export class HomestayDetailComponent implements OnInit {
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
  datas!: Homestay;
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
      this.http.getHomestayDetailByName(this.name).subscribe({
        next: async (data: any) => {
          if (data) {
            const value = data;
            this.urls = [];
            this.urls4 = [];
            console.log(value.homestayFacilities);
            this.datas = {
              address: value.address,
              availableRooms: value.availableRooms,
              businessLicense: value.businessLicense,
              homestayFacilities: value.homestayFacilities,
              homestayImages: value.homestayImages,
              homestayRules: value.homestayRules,
              homestayServices: value.homestayServices,
              name: value.name,
              numberOfRating: value.numberOfRating,
              price: value.price,
              ratings: value.rating,
              status: value.status,
              totalAverageRating: value.totalAverageRating,
            };
            console.log('value', value);
            console.log('this.datas', this.datas);
            for (this.url of value.homestayImages) {
              await this.image
                .getImage(('homestay/' + this.url.imageUrl) as string)
                .then((url) => {
                  let urls = url as string;
                  this.urls.push(urls);
                });
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
            var priceToFixed = (this.datas.price * 0.95).toFixed();
            this.priceTax = priceToFixed as unknown as number;
          }
        },
        error: (error) => {
          this.message = 'Bạn chưa có lịch đặt nào cả';
          this.openDialogMessage;
        },
      });
    } catch (error) {
      this.message = error as string;
      this.openDialogMessage();
      console.log(error);
    }
  }
}
