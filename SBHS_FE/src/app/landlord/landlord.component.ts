import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';

import { ImageService } from '../services/image.service';
import { MediaMatcher } from '@angular/cdk/layout';

@Component({
  selector: 'app-landlord',
  templateUrl: './landlord.component.html',
  styles: [`.gradient-custom-2 {
    /* fallback for old browsers */
    background: #fccb90;

    /* Chrome 10-25, Safari 5.1-6 */
    background: -webkit-linear-gradient(to right, #FFCE03, #FD9A01, #FD6104, #FF2C05);

    /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */
    background: linear-gradient(to right, #FFCE03, #FD9A01, #FD6104, #FF2C05);
  }

  .btn-register {
    color: white !important;
    font-weight: 500;
  }

  .li-login {

    border-radius: 5px;
    width: fit-content;

    button {
      color: rgb(1, 148, 243);
      font-family: MuseoSans, Roboto, sans-serif !important;
      font-size: 20px;
      letter-spacing: 0.7px;
      font-weight: 500;

    }
  }

  .logo-isExpanded {
    height: 53px;
    max-height: 53px;
    min-height: 53px;
  }

  .logo {
    height: 49px;
    max-height: 49px;
    min-height: 49px;
  }


  .left {
    max-width: 256px;
    min-width: 256px;
  }

  .example-container {
    display: flex;
    flex-direction: column;
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
  }

  :host ::ng-deep .mat-drawer-content,
  .mat-drawer {
    overflow: unset !important;
    overflow-y: unset !important;
  }

  :host ::ng-deep .mat-drawer-inner-container {
    overflow: unset !important;
  }


  /* width  left */
  #left::-webkit-scrollbar {
    display: none;
  }


  #right::-webkit-scrollbar-track {
    -webkit-box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
    background-color: #F5F5F5;
  }

  #right::-webkit-scrollbar {
    width: 10px;
    background-color: #F5F5F5;
  }

  #right::-webkit-scrollbar-thumb {
    border-radius: 10px;
    background-color: #fd5f04;
    background-image: -webkit-linear-gradient(45deg,
        rgba(255, 255, 255, 0.3) 25%,
        transparent 25%,
        transparent 50%,
        rgba(255, 255, 255, 0.3) 50%,
        rgba(255, 255, 255, 0.3) 75%,
        transparent 75%,
        transparent)
  }

  .navbar {
    height: 64px;
    max-height: 64px;
    min-height: 64px;
  }

  .main-content {
    height: calc(100vh - 64px);
    max-height: calc(100vh - 64px);
    min-height: calc(100vh - 64px);
  }

  .sidenav {
    position: absolute;
    top: 0px;
    left: 0px;
    width: 100%;
    height: 100%;
    z-index: 1;
    background-image: linear-gradient(315deg, #FFFF00cc, #FD9A01cc, #FD6104cc, #FF2C05cc, );
    background-image: -webkit-linear-gradient(315deg, #FFFF00cc, #FD9A01cc, #FD6104cc, #FF2C05cc, );
  }


  .user {

    .icon {
      .avatar {
        width: 40px;
        max-width: 40px;
      }
    }

    .username {
      .name {
        width: 63px;

        font-size: 18px;
        min-height: 19px;
        line-height: 18px;
        text-overflow: ellipsis;
        display: -webkit-box;
        -webkit-line-clamp: 1;
        -webkit-box-orient: vertical;
      }

      .roles {
        font-size: 12px;
        font-weight: 400;
      }
    }

    .collapse-avatar {
      .btn-collapse-avatar {
        font-size: 20px;
      }
    }

    .logout {
      .btn-logout {
        font-size: 20px;
        color: #9a9a9a;
      }
    }
  }

  .active {
    background-image: linear-gradient(to right, #FFCE03, #FD9A01, #FD6104, #FF2C05, );
    background-image: -webkit-linear-gradient(to right, #FFCE03, #FD9A01, #FD6104, #FF2C05, );
  }

  .sidenav-link-text {
    font-size: 15px;
  }

  .menu-button {
    transition: 300ms ease-in-out;
    transform: rotate(0deg);
  }

  .menu-button.rotated {
    transform: rotate(180deg);
  }

  .submenu {
    display: none;
    overflow-y: hidden;
    transition: transform 300ms ease;
    transform: scaleY(0);
    transform-origin: top;
    padding-left: 30px;
  }

  .submenu.expanded {
    display: block;
    transform: scaleY(1);
  }

  :host ::ng-deep .sidenav-nav-link .mat-expansion-panel-body {
    padding-bottom: unset;
    padding-right: unset;
  }

  :host ::ng-deep .sidenav-link-icon {
    margin-right: 16px !important;
    margin-left: 16px !important;
    font-size: 22px;
  }

  :host ::ng-deep .sidenav-nav-link .mat-expansion-panel-header {
    padding: 0px 16px;
  }
  `],
})
export class LandlordComponent implements OnInit {
  public username = localStorage.getItem('usernameLogined');
  public role = localStorage.getItem('role');
  public url:any;
  constructor(
    public router: Router,
    private route: ActivatedRoute,
    private image: ImageService,
    media: MediaMatcher,
    changeDetectorRef: ChangeDetectorRef
  ) {
    this.mobileQuery = media.matchMedia('(max-width: 600px)');
    this._mobileQueryListener = () => changeDetectorRef.detectChanges();
    this.mobileQuery.addListener(this._mobileQueryListener);
  }
  public avatarUrl = '';
  ngOnInit(): void {

  }

  public logout() {
    localStorage.clear();
    this.router.navigate(['/Login'], { relativeTo: this.route });
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
  toggle() {
    const panelBody = document.querySelectorAll<HTMLElement>(
      '.mat-expansion-panel-body'
    );
    if (this.isExpanded == true) {
      for (let i = 0; i < panelBody.length; i++) {
        panelBody[i].style.padding = '0 0 0 16px';
      }
    } else {
      for (let i = 0; i < panelBody.length; i++) {
        panelBody[i].style.padding = '0';
      }
    }
  }

}
