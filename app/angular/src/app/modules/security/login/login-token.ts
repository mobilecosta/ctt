import { BehaviorSubject, Observable } from 'rxjs';
import { AccessToken } from './access-token';
import { utf8Encode } from '@angular/compiler/src/util';

export class LoginToken {
  private loginSubject: BehaviorSubject<LoginToken>;

  private expToken: Date = new Date(0);
  private iatToken: Date = new Date(0);
  private emailToken: string;
  private tenantIdToken: number;
  private subjectToken: string;

  constructor(private accessToken: AccessToken) {
    const payload = JSON.parse(
      atob(accessToken.authorization.split('.')[TokenParts.Payload])
    );
    this.emailToken = String(payload['email']);
    this.tenantIdToken = Number(payload['tenantid']);
    this.subjectToken = String(payload['sub']);
    this.iatToken.setUTCSeconds(payload['iat']);
    this.expToken.setUTCSeconds(payload['exp']);

    this.loginSubject = new BehaviorSubject<LoginToken>(this);
  }

  get tenantId(): number{
    return this.tenantIdToken;
  }

  get email(): string {
    return this.emailToken;
  }

  get expiration(): Date {
    return this.expToken;
  }

  get issuedAt(): Date {
    return this.iatToken;
  }

  get isValid(): boolean {
    return new Date().valueOf() < this.expToken.valueOf();
  }

  get jwtToken(): string {
    return this.accessToken.authorization;
  }

  get name(): string {
    return this.subjectToken;
  }

  getLoginSubject(): Observable<LoginToken> {
    return this.loginSubject.asObservable();
  }
}

enum TokenParts {
  Header,
  Payload,
  Sign,
}
