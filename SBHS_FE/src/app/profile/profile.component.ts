import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MessageComponent } from '../pop-up/message/message.component';
import { SuccessComponent } from '../pop-up/success/success.component';
import { UserService } from '../services/user.service';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styles: [`.card-header{
    h1:after {
      content: '';
      display: block;
      width: 60px;
      height: 3px;
      background: #ee2c74;
      margin-top: 5px;
    }
  }

  .password,
  .username {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 16px;
  }

  input:-webkit-autofill,
  input:-webkit-autofill:hover,
  input:-webkit-autofill:focus,
  input:-webkit-autofill:active {
    transition: background-color 5000s ease-in-out 0s !important;
  }

  .gradient-custom-2 {
    /* fallback for old browsers */
    background: rgb(238, 42, 123) 0%;

    /* Chrome 10-25, Safari 5.1-6 */
    background: -webkit-linear-gradient(to right, rgb(238, 42, 123) 0%, rgb(255, 125, 184) 100%);

    /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */
    background: linear-gradient(to right, rgb(238, 42, 123) 0%, rgb(255, 125, 184) 100%);
  }
  .card-img-top{
    min-height: 150px;
  }
  .posttitle-text {
    font-weight: 500;
    border-left: 3px solid #ee2c74;
    padding-left: 10px;
    line-height: 1.5;
    min-height: 27px;
  }
  .balance {


    #info-block {

      section {
        border: 1px solid black;
        border-radius: 1rem;
      }
    }


    .file-marker>div {
      padding: 0 3px;
      margin-top: -0.9em;
      }

    .box-title {
      background: rgb(255 255 255) none repeat scroll 0 0;
      display: inline-block;
      padding: 0 4px;
      text-align: center;
      font-size: 13px;
    }

    .box-footer {
      // background: rgb(237 238 239) none repeat scroll 0 0;
      display: inline-block;
      margin: 5px 0px;
      text-align: center;
      font-size: 13px;
      width: 100%;

      .btn-add {
        padding: 0%;
        width: 100%;
        border-radius: 7px;
        margin: 0;
        font-size: 16px;
        font-weight: 500;
        // background-color: rgb(248, 33, 119);
        margin-bottom: 5px;
        box-shadow: 0px 3px 1px -2px rgb(0 0 0 / 20%), 0px 2px 2px 0px rgb(0 0 0 / 14%), 0px 1px 5px 0px rgb(0 0 0 / 12%);
        cursor: pointer;
        box-sizing: border-box;
        position: relative;
        line-height: 36px;
        text-align: left;
        padding-left: 20px;

        i {
          margin-right: 9px;
        }


      }


    }

    .money{
      margin-top: -0.4em;
    }

  }
  `],
})
export class ProfileComponent implements OnInit {
  id: any;
  username: any;
  email!: string;
  status: any;
  avatarUrl: any;
  phone: any;
  dob: any;
  address!: string;
  minDate!: Date;
  maxDate!: Date;
  password: any;
  isUpdate = false;

  constructor(public dialog: MatDialog, private http: UserService) {
    const currentYear = new Date().getFullYear();
    const currentDate = new Date();
    currentDate.setDate(currentDate.getDate() - 1);
    this.minDate = new Date(currentYear - 100, 0, 0);
    this.maxDate = new Date(currentDate);


  }
  ngOnInit(): void {
    try {
      const username = localStorage.getItem('usernameLogined') as string;
      this.http.getUserInfo(username).subscribe(
        (data) => {
          console.log(data);
          this.username = data.username;
          this.email = data.email;
          this.phone = data.phone;
          this.dob = data.dob;
          this.address = data.address;
          this.balance = data.landlordProperty.balanceWallet.totalBalance;
        },
        (error) => {
          this.message = error;
          this.openDialogMessage();
        }
      );
    } catch (error) {
      this.message = error;
      this.openDialogMessage();
    }

  }
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
  hidePassword = true;
  hideConfirmPass = true;
  message: any;
  value: any;

  filter = /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/;
  filterPhone = /^[0]\d{9,12}$/;
  validMail: boolean = true;
  validPhone: boolean = true;
  public valid() {
    this.validMail = this.filter.test(this.email + '');
    this.validPhone = this.filterPhone.test(this.phone + '');
    if (this.username == '') {
      this.username = this.value.username;
    } else if (this.address == '') {
      this.address = this.value.address;
    } else if (this.dob == '') {
      this.dob = this.value.dob;
    } else if (this.email == '') {
      this.email = this.value.quantity;
    } else if (this.phone == '') {
      this.phone = this.value.phone;
    } else if (this.validMail == false) {
      this.message = 'Email không hợp lệ';
      this.isValid = false;
      this.openDialogMessage();
    } else if (this.validPhone == false) {
      this.message = 'Phone không hợp lệ';
      this.isValid = false;
      this.openDialogMessage();
    } else this.isValid = true;
  }
  isValid!: boolean;

  convert(event: any): void {
    console.log(event);
    var date = new Date(event),
      mnth = ('0' + (date.getMonth() + 1)).slice(-2),
      day = ('0' + date.getDate()).slice(-2);
    this.dob = [date.getFullYear(), mnth, day].join('-');
    console.log('convert', this.dob);
  }

  checkPassword() {
    let password = localStorage.getItem('password') as string;
    if (this.password == password) {
      this.isUpdate = true;
    } else {
      this.isUpdate = false;
      this.message = 'Sai mật khẩu';
      this.openDialogMessage();
    }
  }
  balance: any;
  showDiv = {
    // profile: true,
    addBalance: false,
    changePass: false,
    cashOut: false,
    editProfile: true,
  };
  toggle = {
    addBalance: false,
    changePass: false,
    cashOut: false,
    editProfile: false,
  };
}
