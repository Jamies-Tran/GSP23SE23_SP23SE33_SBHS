import { ServerHttpService } from './../../services/homestay.service';
import { Component, ChangeDetectorRef, OnInit } from '@angular/core';
import {MediaMatcher} from '@angular/cdk/layout';

@Component({
  selector: 'app-test-two',
  templateUrl: './test-two.component.html',
  styleUrls: ['./test-two.component.scss']
})
export class TestTwoComponent implements OnInit{
name:any;
age:any;
address:any;

  constructor(private http: ServerHttpService){
    // this.name = this.http.getValue();
  }
  ngOnInit(): void {
      this.http.getValue().subscribe(data =>{
        console.log("data" , data);
        this.name = data;
        // var value = data.value;
        // this.age = value[0].age;
        // this.address = value[0].address;

      })
  }
}
