import { Component, OnInit } from '@angular/core';
import { ImageService } from '../../services/image.service';
import { MatDialog } from '@angular/material/dialog';
import { ServerHttpService } from 'src/app/services/homestay.service';

@Component({
  selector: 'app-homestay',
  templateUrl: './homestay.component.html',
  styleUrls: ['./homestay.component.scss']
})
export class HomestayComponent implements OnInit {
  constructor( private image: ImageService,public dialog: MatDialog, private http: ServerHttpService) { }
  value : any[] = [];
  i : any;
  isDelete = "null"
  public username = localStorage.getItem('usernameLogined') as string;
  ngOnInit(): void {

    this.http.getHomestay(this.username).subscribe(async  (data) =>{
      // this.value = data;
      // for(this.i of this.value ){
      //   console.log(this.i.homestayImages[0].url)
      // }
      console.log("data:" ,data['homestays']);
      // this.value= data['homestays'];
      // console.log('value:' , this.value);

      for(this.i of data['homestays']){
        var imgUrl = await this.image.getImage('homestay/'  + this.i.name + ' '+  this.i.homestayImages[0].imageUrl);

        this.value.push({imgURL:imgUrl, name:this.i.name, id:this.i.id ,status:this.i.status})
        console.log(this.value);
      }

    })

  }
  getHomestayName(name: string){
    localStorage.setItem('homestayName',name);
  }
  id: string =""
  getHomestayId(id: string){
    this.id = id
  }
  deleteHomestay(){
    this.http.deleteHomestay(this.id).subscribe((data =>{
      this.isDelete = "true"
    }),
    error =>{
      this.isDelete = "false"
    })
  }
  openDialog() {
    // this.dialog.open(DeleteHomestayDialogComponent,{
    //   data : this.id
    // });

  }
}
