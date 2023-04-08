import { Injectable } from '@angular/core';
import {
  HttpClient,
  HttpHeaders,
  HttpErrorResponse,
} from '@angular/common/http';
import { throwError } from 'rxjs/internal/observable/throwError';
import { Observable, catchError } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class BookingService {
  private REST_API_SERVER = 'http://localhost:8081';
  private httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' }),
  };
  constructor(private httpClient: HttpClient) {}
  private handleError(error: HttpErrorResponse) {
    return throwError(error.error['message']);
  }
  //  GET
  //  /api/booking/landlord/booking-list
  public getBookingForLandlord(name: string): Observable<any> {
    this.httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json ',
        Authorization: 'Bearer ' + localStorage.getItem('userToken'),
      }),
    };
    const url = `${this.REST_API_SERVER}/api/booking/landlord/booking-list?homestayName=${name}`;
    return this.httpClient
      .get<any>(url, this.httpOptions)
      .pipe(catchError(this.handleError));
  }

  // PUT
  // /api/booking/accept  acceptBookingForHomestay
  public acceptBookingForHomestay(
    bookingId: number,
    homestayId: number
  ): Observable<any> {
    this.httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json ',
        Authorization: 'Bearer ' + localStorage.getItem('userToken'),
      }),
    };
    const url = `${this.REST_API_SERVER}/api/booking/accept?bookingId=${bookingId}&homestayId=${homestayId}`;
    return this.httpClient
      .put<any>(url, null, this.httpOptions)
      .pipe(catchError(this.handleError));
  }

  // PUT
  // /api/booking/reject rejectBookingForHomestay
  public rejectBookingForHomestay(
    bookingId: number,
    homestayId: number,
    message:string
  ): Observable<any> {
    this.httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json ',
        Authorization: 'Bearer ' + localStorage.getItem('userToken'),
      }),
    };
    const value = {message:message};
    const url = `${this.REST_API_SERVER}/api/booking/reject?bookingId=${bookingId}&homestayId=${homestayId}`;
    return this.httpClient
      .put<any>(url, value, this.httpOptions)
      .pipe(catchError(this.handleError));
  }
}
