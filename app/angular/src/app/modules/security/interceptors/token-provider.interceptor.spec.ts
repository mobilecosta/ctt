import { TestBed } from '@angular/core/testing';

import { TokenProviderInterceptor } from './token-provider.interceptor';

describe('TokenProviderInterceptor', () => {
  beforeEach(() => TestBed.configureTestingModule({
    providers: [
      TokenProviderInterceptor
      ]
  }));

  it('should be created', () => {
    const interceptor: TokenProviderInterceptor = TestBed.inject(TokenProviderInterceptor);
    expect(interceptor).toBeTruthy();
  });
});
