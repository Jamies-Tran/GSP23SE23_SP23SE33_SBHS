import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RegisterHomestayImageComponent } from './register-homestay-image.component';

describe('RegisterHomestayImageComponent', () => {
  let component: RegisterHomestayImageComponent;
  let fixture: ComponentFixture<RegisterHomestayImageComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RegisterHomestayImageComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(RegisterHomestayImageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
