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
      'Content-Type': 'application/json ; charset=utf-8 ;charset=ISO-8859-1',
      // "Accept": "application/json;charset=utf-8",
      // 'Accept-Charset':'charset=utf-8',
      'Content-Transfer-Encoding': 'utf-8',
      Authorization: 'Bearer ' + localStorage.getItem('userToken'),
    }),
  };
  public model: any = {};
  private REST_API_SERVER = 'http://localhost:8081';
  constructor(private httpClient: HttpClient) {}

  public getLanlord(status: string) {
    const url = `${this.REST_API_SERVER}/api/admin/landlord-list?isNextPage=true&isPreviousPage=true&page=0&size=1000&status=`+status+``;
    return this.httpClient
      .get<any>(url, this.httpOptions)
      .pipe(catchError(this.handleError));
  }
  public verifyLandlord(
    username: string,
    isAccept: string
  ) {
    const url =
      `${this.REST_API_SERVER}/api/admin/landlord-activate?username=`+username+``;
    return this.httpClient
      .put<any>(url, "accept",this.httpOptions)
      .pipe(catchError(this.handleError));
  }
  public getLandlordDetail() {
    const url =
      `${this.REST_API_SERVER}/api/user/get/` +
      localStorage.getItem('createdBy') +
      ``;
    return this.httpClient
      .get<any>(url, this.httpOptions)
      .pipe(catchError(this.handleError));
  }

  private handleError(error: HttpErrorResponse) {
    return throwError(error.error['message']);
  }
}
