import { TestBed } from '@angular/core/testing';

import { ServerHttpService } from './verify-landlord.service';

describe('VerifyLandlordService', () => {
  let service: ServerHttpService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ServerHttpService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
