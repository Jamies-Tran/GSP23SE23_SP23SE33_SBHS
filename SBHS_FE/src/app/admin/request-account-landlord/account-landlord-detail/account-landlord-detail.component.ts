import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ImageService } from 'src/app/services/image.service';
import { Router, ActivatedRoute } from '@angular/router';

import { MessageComponent } from '../../../pop-up/message/message.component';
import { SuccessComponent } from '../../../pop-up/success/success.component';
import { AdminService } from '../../../services/admin.service';
import { UserService } from '../../../services/user.service';

@Component({
  selector: 'app-account-landlord-detail',
  templateUrl: './account-landlord-detail.component.html',
  styleUrls: ['./account-landlord-detail.component.scss'],
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
    private route: ActivatedRoute
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
  ngOnInit(): void {
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

          console.log(this.citizenIdentificationUrlBack);
          console.log(this.citizenIdentificationUrlFont);
          console.log(this.avatarUrl);
          console.log("font url:" , fontImage);
          console.log("back url:" , backImage);

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
    const name = localStorage.getItem('username') as string;
    this.httpAdmin.activateLandlordAccount(name).subscribe(
      (data) => {
        if (data != null) {
          this.message = 'Account have accept';
          this.openDialogSuccess();
          this.router.navigate(['/Admin/RequestAccountLandlord'], {
            relativeTo: this.route,
          });
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
  public reject() {
    this.httpAdmin
      const name = localStorage.getItem('username') as string;

      this.httpAdmin.rejectLandlordAccount(name, 'NOT_MATCHED')
      .subscribe(
        (data) => {
          if (data != null) {
            this.message = 'Account have reject';
            this.openDialogSuccess();
            // location.reload();
            this.router.navigate(['/Admin/RequestAccountLandlord'], {
              relativeTo: this.route,
            });
          }
        },
        (error) => {
          if (error['status'] == 500) {
            this.registerError = 'please check your information again!';
            this.message = error;
            this.openDialogMessage();
          } else {
            this.registerError = error;
            this.message = error;

            this.openDialogMessage();
          }
        }
      );
  }
}
