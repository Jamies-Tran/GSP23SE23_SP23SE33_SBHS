import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { ImageService } from 'src/app/services/image.service';
import { Router, ActivatedRoute } from '@angular/router';

import { MessageComponent } from '../../../pop-up/message/message.component';
import { SuccessComponent } from '../../../pop-up/success/success.component';
import { AdminService } from '../../../services/admin.service';
import { UserService } from '../../../services/user.service';
import { ActionPendingComponent } from '../../../pop-up/action-pending/action-pending.component';

@Component({
  selector: 'app-account-landlord-detail',
  templateUrl: './account-landlord-detail.component.html',
  styles: [`
  .wrapper {


.header {
  padding-left: 2%;
  padding-top: 1%;
}

.card {
  box-shadow: 0 0 5px #c4cacc;
  padding: 0 1%;
}

.body {
  margin-top: 1%;

  .body-container {

    display: flex;
    flex-direction: column;
    margin: 0 2%;
    padding: 1%;

    .row-avatar-infor {
      display: flex;

      .avatar {

        img {
          min-width: 130px;
          max-width: 130px;
          min-height: 130px;
        }

      }

      .infor {

        width: 100%;

        .col-left {

          float: left;
          width: 50%;

        }

        .col-right {

          float: left;
          width: 50%;
        }

        .fill {
          font-size: 20px;
          font-weight: 400;
          margin-left: 10%;
          display: flex;
          margin-bottom: 40px;

          .fill-text {
            float: left;
            width: 130px;
            overflow: hidden;
            height: 26px;



          }

          .fill-input {
            float: left;
            width: 70%;
            border-bottom: 1px solid black;
            padding-left: 20px;
            height: 25px;
            overflow: hidden;
          }
        }
      }
    }

    .IDcard {
      .image {
        display: flex;
        text-align: center;
        font-size: 20px;

        img {
          width: 90%;
        }

        .after {
          width: 52.5%;
          padding: 0 2.5%;

          img {
            min-width: 50%;
            min-height: 100px;
            max-height: 30vw;

          }

        }

        .before {
          width: 52.5%;
          padding: 0 2.5%;

          img {
            min-width: 50%;
            min-height: 100px;
          }
        }
      }
    }

    .button {
      align-items: center;
      justify-content: center;
      text-align: center;
      margin: 2%;

      .btn-accept {
        padding: 0%;
        width: 100px;
        margin: 0 1%;
        font-size: large;
        font-weight: 500;
        background-color: rgb(248, 33, 119);

      }

      .btn-denied {
        padding: 0%;
        border-radius: 5px;
        width: 100px;
        background-color: #D9D9D9;
        margin: 0 1%;
        font-size: large;
        font-weight: 500;
      }
    }
  }
}
}

.fill-input {


border-bottom: 1px solid rgb(0 0 0 / 30%);
padding-left: 10px;
height: 25px;

}

@media (min-width:992px) {
.address-text {
  width: 25% !important;
}

.address-input {
  width: 66.66666667% !important;
}
}

@media (min-width:768px) {
.address-text {
  width: 25% !important;
}

.address-input {
  width: 66.66666667% !important;
}
}

@media (min-width: 1200px) {
.address-text {
  width: 128px !important;
}

.address-input {
  width: 83% !important;
}
}

  `],
})
export class AccountLandlordDetailComponent implements OnInit {
  registerError: string = '';
  message!: string;
  constructor(
    private httpUser: UserService,
    private httpAdmin: AdminService ,
    public dialog: MatDialog,
    private image: ImageService,
    private router: Router,
    private route: ActivatedRoute,
    public dialogRefSuccess : MatDialogRef<SuccessComponent>
  ) {}
  public username = '';
  public email = '';
  public phone = '';
  public gender = '';
  public citizenIdentificationString = '';
  public dob = '';
  public address = '';
  public avatarUrl = '';
  public citizenIdentificationUrlFont = '';
  public citizenIdentificationUrlBack = '';
  status !: string;
  ngOnInit(): void {
   this.getAccountDetail();
  }
  getAccountDetail(){
    this.username = '';
    this.email = '';
    this.phone = '';
    this.gender = '';
    this.citizenIdentificationString = '';
    this.dob = '';
    this.address = '';
    this.avatarUrl = '';
    this.citizenIdentificationUrlFont = '';
    this.citizenIdentificationUrlBack = '';
    this.status = '';
    try {
      const name = localStorage.getItem('createdBy') as string;
      this.httpUser.getUserInfo(name).subscribe(
        async (data) => {
          this.username = data['username'];
          this.dob = data['dob'];
          this.email = data['email'];
          this.citizenIdentificationString =
            data['idCardNumber'];
          this.gender = data['gender'];
          this.phone = data['phone'];
          this.address = data['address'];
          this.status = data.landlordProperty.status;
          console.log('avatar', data['avataUrl']);
          if (data['avataUrl']) {
            this.avatarUrl = await this.image.getImage(
              'landlord/avatar/' + data['avataUrl']
            );
          } else {
            this.avatarUrl = await this.image.getImage(
              'landlord/avatar/default.png'
            );
          }
          var landlordProperty = data['landlordProperty'];
          var fontImage = landlordProperty.idCardFrontImageUrl;
          var backImage = landlordProperty.idCardBackImageUrl;
          this.citizenIdentificationUrlFont = await this.image.getImage(
            'landlord/citizenIdentification/' +
              fontImage
          );
          this.citizenIdentificationUrlBack = await this.image.getImage(
            'landlord/citizenIdentification/' +
              backImage
          );
          console.log("data" , data);

        },
        (error) => {
          this.message = error.message;
          console.log(this.message);
          this.openDialogMessage();
        }
      );
    } catch (error) {
      console.log(error);
      this.openDialogMessage();
    }
  }
  openDialogMessage() {
    localStorage.setItem('account-landlord-detail', 'true');
    this.dialog.open(MessageComponent, {
      data: this.message,
    });
  }
  openDialogSuccess() {
    this.dialog.open(SuccessComponent, {
      data: this.message,
    });
  }
  public isAccept = true;
  public isReject = false;
  public rejectMessage = '';
  public accept() {

    this.httpAdmin.activateLandlordAccount(this.username).subscribe(
      (data) => {
        if (data != null) {
          this.message = 'Account have accept';
          this.openDialogSuccess();
          this.getAccountDetail();
        }

        console.log(data);
      },
      (error) => {
        if (error['status'] == 500) {
          this.registerError = 'please check your information again!';
          this.message = this.registerError;
          this.message = this.registerError;
          this.openDialogMessage();
        } else {
          this.registerError = error;
          this.message = error;
          this.message = this.registerError;
          this.openDialogMessage();
        }
      }
    );
  }

  openDialogAction() {
    const dialogRef = this.dialog.open(ActionPendingComponent, {
      data: {
        username: this.username,
        isReject:this.isReject
      },
      disableClose: true
    });
    dialogRef.afterClosed().subscribe(()=>{
      setTimeout(() =>{
        this.getAccountDetail();
      } , 4000)
    })
  }
}
