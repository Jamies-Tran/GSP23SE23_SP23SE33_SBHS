import { Component,Inject  } from '@angular/core';
import { MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';
@Component({
  selector: 'app-action-pending',
  templateUrl: './action-pending.component.html',
  styleUrls: ['./action-pending.component.scss']
})
export class ActionPendingComponent {
  constructor(@Inject(MAT_DIALOG_DATA) public data: string) {};
}
