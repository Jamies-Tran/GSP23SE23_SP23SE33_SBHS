import { Component } from '@angular/core';

@Component({
  selector: 'app-category-homestay',
  templateUrl: './category-homestay.component.html',
  styles: [`
  .card-body{

    .body-content{
      width: 270px;
      height: 175px;
      overflow: hidden;
    }
    .image{
      min-width: 280px;
      min-height: 170px;

    }
    .image-bloc{
      img{
        width: 190px;
      }
    }
  }

  .button-choose{
    button{
      background-color: #03A9F4;
      color: white;

    }

  }
  `]
})
export class CategoryHomestayComponent {

}
