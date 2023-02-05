import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse, HttpHeaders } from '@angular/common/http';
import { throwError } from 'rxjs/internal/observable/throwError';
import { catchError, Observable, tap } from 'rxjs';

@Injectable({
  providedIn: 'root'
})

export class ServerHttpService {
  private httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json',
      //'Authorization': 'my-auth-token'
    })
  };

  public model:any = {};
  private REST_API_SERVER = 'http://localhost:8080';

  constructor(private httpClient: HttpClient) { }

  public login(userInfo : string, password:string) {
    var value = {
      userInfo,password
    }
    const url =`${this.REST_API_SERVER}/api/user/login`;
    return this.httpClient
    .post<any>(url,value ,this.httpOptions)
    .pipe(catchError(this.handleError));
  }


  private handleError(error: HttpErrorResponse) {
    return throwError(
      error.error["message"]);
  };

}