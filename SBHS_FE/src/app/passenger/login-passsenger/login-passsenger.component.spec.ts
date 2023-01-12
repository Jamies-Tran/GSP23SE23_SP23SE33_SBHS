import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LoginPasssengerComponent } from './login-passsenger.component';

describe('LoginPasssengerComponent', () => {
  let component: LoginPasssengerComponent;
  let fixture: ComponentFixture<LoginPasssengerComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ LoginPasssengerComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(LoginPasssengerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
