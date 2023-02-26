import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RegisterHomestayOverviewComponent } from './register-homestay-overview.component';

describe('RegisterHomestayOverviewComponent', () => {
  let component: RegisterHomestayOverviewComponent;
  let fixture: ComponentFixture<RegisterHomestayOverviewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RegisterHomestayOverviewComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(RegisterHomestayOverviewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
