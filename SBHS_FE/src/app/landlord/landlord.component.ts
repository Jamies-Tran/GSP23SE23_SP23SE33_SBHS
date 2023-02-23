import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { ImageService } from '../services/image.service';

@Component({
  selector: 'app-landlord',
  templateUrl: './landlord.component.html',
  styleUrls: ['./landlord.component.scss']
})
export class LandlordComponent implements OnInit{
  public username = localStorage.getItem('username');
  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private image: ImageService
  ) {}
  public avatarUrl = '';
  ngOnInit(): void {}
  public logout() {
    localStorage.clear();
    this.router.navigate(['/Login'], { relativeTo: this.route });
  }
}
