import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RegisterHomestayPriceComponent } from './register-homestay-price.component';

describe('RegisterHomestayPriceComponent', () => {
  let component: RegisterHomestayPriceComponent;
  let fixture: ComponentFixture<RegisterHomestayPriceComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RegisterHomestayPriceComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(RegisterHomestayPriceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
