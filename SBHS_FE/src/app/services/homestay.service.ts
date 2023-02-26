import { HttpClient, HttpErrorResponse, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { throwError } from 'rxjs/internal/observable/throwError';
import { catchError } from 'rxjs/internal/operators/catchError';

@Injectable({
  providedIn: 'root'
})

export class ServerHttpService {
  private httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization' :  'Bearer '+ localStorage.getItem('userToken')
    })
  };
  public model: any = {};
  private REST_API_SERVER = 'http://localhost:8081';
  constructor(private httpClient: HttpClient) { }

  public getHomestayList(){
    const url = `${this.REST_API_SERVER}/api/homestay/owner-list`;
    return this.httpClient
      .get<any>(url, this.httpOptions)
      .pipe(catchError(this.handleError));
  }
  public getHomestayDetail(){
    const url = `${this.REST_API_SERVER}/api/homestay/permit-all/details/`+ localStorage.getItem('homestayName')+``;
    return this.httpClient
      .get<any>(url, this.httpOptions)
      .pipe(catchError(this.handleError));
  }
  private handleError(error: HttpErrorResponse) {
    return throwError(
      error.error["message"]);
  };
  public getSpecialDay() {
    const url = `${this.REST_API_SERVER}/api/homestay/get/all/special-day`;
    return this.httpClient
      .get<any>(url, this.httpOptions)
      .pipe(catchError(this.handleError));
  }
  public deleteHomestay(id:string) {
    const url = `${this.REST_API_SERVER}/api/homestay/removal/`+id+``;
    return this.httpClient
      .delete<any>(url, this.httpOptions)
      .pipe(catchError(this.handleError));
  }
  public registerHomestay(
    name: string,
    address: string,
    availableRooms: string,
    businessLicense: string,
    homestayImages: Array<any>,
    homestayServices: Array<any>,
    homestayFacilities: Array<any>,
    price: string
  ) {
    var value = {
      address,
      availableRooms,
      businessLicense,
      homestayFacilities,
      homestayImages,
      homestayServices,
      name,
      price
    };
    console.log(value);
    const url = `${this.REST_API_SERVER}/api/homestay/new-homestay`;
    return this.httpClient
      .post<any>(url, value, this.httpOptions)
      .pipe(catchError(this.handleError));
  }
}
