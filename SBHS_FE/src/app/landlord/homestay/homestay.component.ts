import { Component, OnInit } from '@angular/core';
import { ImageService } from '../../services/image.service';
import { MatDialog } from '@angular/material/dialog';
import { HomestayService } from 'src/app/services/homestay.service';

@Component({
  selector: 'app-homestay',
  templateUrl: './homestay.component.html',
  styleUrls: ['./homestay.component.scss']
})
export class HomestayComponent implements OnInit {
  constructor( private image: ImageService,public dialog: MatDialog, private http: HomestayService) { }
  value : any[] = [];
  i : any;
  isDelete = "null"
  public username = localStorage.getItem('usernameLogined') as string;
  ngOnInit(): void {
    this.username = localStorage.getItem('usernameLogined') as string;
    console.log(this.username);
    this.http.getHomestayByLandlord(this.username).subscribe(async  (data) =>{
      // this.value = data;
      // for(this.i of this.value ){
      //   console.log(this.i.homestayImages[0].url)
      // }
      console.log("data:" ,data['homestays']);
      // this.value= data['homestays'];
      // console.log('value:' , this.value);

      for(this.i of data['homestays']){
        var imgUrl ;
        await this.image.getImage('homestay/'  +   this.i.homestayImages[0].imageUrl).then(url =>{
          imgUrl = url;

        this.value.push({imgURL:imgUrl, name:this.i.name, id:this.i.id ,status:this.i.status})
        console.log(this.value);
        }).catch(error =>{
          console.log(error);
        });

      }

    })

  }
  getHomestayName(name: string){
    sessionStorage.setItem('name',name);
  }
  id: string =""
  getHomestayId(id: string){
    this.id = id
  }

  openDialog() {
    // this.dialog.open(DeleteHomestayDialogComponent,{
    //   data : this.id
    // });

  }
}
