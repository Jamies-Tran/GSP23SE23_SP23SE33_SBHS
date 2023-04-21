import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-promotion-overview',
  templateUrl: './promotion-overview.component.html',
  styleUrls: ['./promotion-overview.component.scss']
})
export class PromotionOverviewComponent implements OnInit{
constructor(){}
ngOnInit(): void {

}
valuesProgress: any[] = [];
id:any;
username:any;

// valuesProgress
pageProgress: number = 1;
countProgress: number = 0;
tableSizeProgress: number = 5;

onTableDataChangeProgress(event: any) {
  this.pageProgress = event;
  this.valuesProgress;
}

public onItemSelector(id: number, createdBy: string) {
  this.id = id;
  this.username = createdBy;
  localStorage.setItem('id', id + '');
  sessionStorage.setItem('name' ,createdBy );
}
}
