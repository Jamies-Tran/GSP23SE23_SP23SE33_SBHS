import { MediaMatcher } from '@angular/cdk/layout';
import { DatePipe } from '@angular/common';
import { Component, OnInit, AfterViewInit, ViewChild, ChangeDetectorRef } from '@angular/core';


@Component({
  selector: 'app-test',
  templateUrl: './test.component.html',
  styleUrls: ['./test.component.scss'],
})
export class TestComponent  {
  logout(){}
  constructor(media: MediaMatcher,
    changeDetectorRef: ChangeDetectorRef,){
      this.mobileQuery = media.matchMedia('(max-width: 600px)');
    this._mobileQueryListener = () => changeDetectorRef.detectChanges();
    this.mobileQuery.addListener(this._mobileQueryListener);

    }
    mobileQuery: MediaQueryList;
    private _mobileQueryListener: () => void;
    ngOnDestroy(): void {
      this.mobileQuery.removeListener(this._mobileQueryListener);
    }
    isExpanded = true;
  showSubmenu: boolean = false;
  isShowing = false;
  showSubSubMenu: boolean = false;



   toggle(){
    const panelBody = document.querySelectorAll<HTMLElement>('.mat-expansion-panel-body');
    if(this.isExpanded == true){
      for(let i =0 ; i<panelBody.length ; i++){
        panelBody[i].style.padding = "0 0 0 16px";
      }
    }else{
      for(let i =0 ; i<panelBody.length ; i++){
        panelBody[i].style.padding = '0';
      }
    }
   }
  }


