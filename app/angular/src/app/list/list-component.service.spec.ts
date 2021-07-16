import { TestBed } from '@angular/core/testing';

import { ListComponentService } from './list-component.service';

describe('ListComponentService', () => {
  let service: ListComponentService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ListComponentService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
