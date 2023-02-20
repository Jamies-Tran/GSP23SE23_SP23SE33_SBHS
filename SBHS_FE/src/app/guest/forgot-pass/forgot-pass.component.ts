import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { ForgetPasswordService } from 'src/app/services/forget-password.service';
import { ImageService } from 'src/app/services/image.service';

@Component({
  selector: 'app-forgot-pass',
  templateUrl: './forgot-pass.component.html',
  styleUrls: ['./forgot-pass.component.scss']
})
export class ForgotPassComponent implements OnInit{
  public comfirmPassword=""  ;
  public username = "";
  public otp = "";
  public newPassword = "";
  constructor(private http: ForgetPasswordService , private router: Router,private aRoute: ActivatedRoute, private imageService:ImageService) { }

  ngOnInit(): void {
  }

  public getOtp() {
    console.log(this.username)
    this.http.inputUserName(this.username).subscribe((data => {

    }),
    error =>{
      alert(error)
    })
  }
  public inputOtp() {
    console.log(this.username)
    this.http.inputOTP(this.username,this.otp).subscribe((data => {

    }),
    error =>{
      alert(error)
    })
  }
  public inputPassword() {
    console.log(this.username)
    this.http.inputPassword(this.username, this.newPassword).subscribe((data => {

    }),
    error =>{
      alert(error)
    })
  }
}
