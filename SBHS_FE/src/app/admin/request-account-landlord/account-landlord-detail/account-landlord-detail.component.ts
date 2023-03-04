import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ImageService } from 'src/app/services/image.service';
import { Router, ActivatedRoute } from '@angular/router';
import { ServerHttpService } from 'src/app/services/verify-landlord.service';
import { MessageComponent } from '../../../pop-up/message/message.component';
import { SuccessComponent } from '../../../pop-up/success/success.component';

@Component({
  selector: 'app-account-landlord-detail',
  templateUrl: './account-landlord-detail.component.html',
  styleUrls: ['./account-landlord-detail.component.scss'],
})
export class AccountLandlordDetailComponent implements OnInit {
  registerError: string = '';
  message!: string;
  constructor(
    private http: ServerHttpService,
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
      this.http.getLandlordDetail().subscribe(
        async (data) => {
          this.username = data['username'];
          this.dob = data['dob'];
          this.email = data['email'];
          this.citizenIdentificationString =
            data['citizenIdentificationString'];
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

          this.citizenIdentificationUrlFont = await this.image.getImage(
            'landlord/citizenIdentification/' +
              data['citizenIdentificationUrlFront']
          );
          this.citizenIdentificationUrlBack = await this.image.getImage(
            'landlord/citizenIdentification/' +
              data['citizenIdentificationUrlBack']
          );

          console.log(this.citizenIdentificationUrlBack);
          console.log(this.citizenIdentificationUrlFont);
          console.log(this.avatarUrl);
          console.log(data['citizenIdentificationUrlFront']);
          console.log(data['citizenIdentificationUrlBack']);
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
    this.http.acceptLandlord(localStorage.getItem('username') + '').subscribe(
      (data) => {
        if (data != null) {
          this.message = 'Account have accept';
          this.openDialogSuccess();
          this.router.navigate(['/Admin/Request'], {
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
    this.http
      .rejectLandlord(localStorage.getItem('username') + '', 'NOT_MATCHED')
      .subscribe(
        (data) => {
          if (data != null) {
            this.message = 'Account have reject';
            this.openDialogSuccess();
            // location.reload();
            this.router.navigate(['/Admin/Request'], {
              relativeTo: this.route,
            });
          }
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
}
