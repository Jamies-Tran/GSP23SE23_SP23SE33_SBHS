import {
  HttpClient,
  HttpErrorResponse,
  HttpHeaders,
} from '@angular/common/http';
import { Injectable } from '@angular/core';
import { throwError } from 'rxjs/internal/observable/throwError';
import { catchError } from 'rxjs/internal/operators/catchError';

@Injectable({
  providedIn: 'root',
})
export class ServerHttpService {
  private httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json',
      //'Authorization': 'my-auth-token'
    }),
  };
  public model: any = {};
  private REST_API_SERVER = 'http://localhost:8081';
  constructor(private httpClient: HttpClient) {}

  public registerLandlord(
    address: string,
    dob: string,
    email: string,
    gender: string,
    idCardNumber: string,
    password: string,
    phone: string,
    username: string
  ) {
    let avatarUrl = '';
    var value = {
      address,
      avatarUrl,
      dob,
      email,
      gender,
      idCardNumber,
      password,
      phone,
      username,
    };
    const url = `${this.REST_API_SERVER}/api/user/registration-landlord`;
    return this.httpClient
      .post<any>(url, value, this.httpOptions)
      .pipe(catchError(this.handleError));
  }
  private handleError(error: HttpErrorResponse) {
    // if (error.error instanceof ErrorEvent) {
    //   // A client-side or network error occurred. Handle it accordingly.
    //   console.error('An error occurred:', error.error.message);
    // } else {
    //   // The backend returned an unsuccessful response code.
    //   // The response body may contain clues as to what went wrong,
    //   console.error(
    //     `Backend returned code ${error.status}, ` +
    //     `body was: ${error.error}`);
    // }
    // // return an observable with a user-facing error message
    return throwError(error.error);
  }
}
