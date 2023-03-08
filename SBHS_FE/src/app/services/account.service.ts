import { Injectable } from '@angular/core';
import {
  HttpHeaders,
  HttpClient,
  HttpErrorResponse,
} from '@angular/common/http';
import { catchError } from 'rxjs';
import { throwError } from 'rxjs/internal/observable/throwError';

@Injectable({
  providedIn: 'root',
})
export class AccountService {
  private httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json',
      Authorization: 'my-auth-token',
    }),
  };

  public model: any = {};
  private REST_API_SERVER = 'http://localhost:8081';

  constructor(private HttpClient: HttpClient) {}

  public getProfile(username: string) {
    var value = {
      username,
    };
    const url = `${this.REST_API_SERVER}/api/user/info?username=${username}`;
    return this.HttpClient.get<any>(url,  this.httpOptions).pipe(
      catchError(this.handleError)
    );
  }

  private handleError(error: HttpErrorResponse) {
    return throwError(error.error['message']);
  }
}
