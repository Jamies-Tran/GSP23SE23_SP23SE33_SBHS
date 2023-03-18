import { DatePipe } from '@angular/common';
import { Component, OnInit, AfterViewInit, ViewChild } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/compat/storage';
import {
  FormControl,
  FormGroupDirective,
  NgForm,
  Validators,
} from '@angular/forms';
import { ErrorStateMatcher } from '@angular/material/core';
import { ActivatedRoute, Router } from '@angular/router';

import { ImageService } from '../../services/image.service';
import { Observable } from 'rxjs';
import {map, startWith} from 'rxjs/operators';
import { MatAutocompleteTrigger } from '@angular/material/autocomplete';
import { MatFormField } from '@angular/material/form-field';

import { MatDialog } from '@angular/material/dialog';
import { MessageComponent } from '../../pop-up/message/message.component';
import { SuccessComponent } from '../../pop-up/success/success.component';
import { ServerHttpService } from 'src/app/services/homestay.service';

@Component({
  selector: 'app-test',
  templateUrl: './test.component.html',
  styleUrls: ['./test.component.scss'],
})
export class TestComponent  {
  name :any;
  age:any;
  address:any;
  value:any[]=[];
  submit(){
    this.value.push({address:this.address, age:this.age});
    var data = {name:this.name , value:this.value};
     console.log(data);

    this.http.setValue(this.name);

    this.http.getValue().subscribe(data =>{
      console.log("data" , data);
      this.address = data;

    })
  }
  constructor(private http: ServerHttpService ){}

}


