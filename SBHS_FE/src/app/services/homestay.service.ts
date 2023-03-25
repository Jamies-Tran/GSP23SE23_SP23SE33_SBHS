import { Injectable } from '@angular/core';
import {
  HttpClient,
  HttpHeaders,
  HttpErrorResponse,
} from '@angular/common/http';
import { throwError } from 'rxjs/internal/observable/throwError';
import { catchError } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class HomestayService {

  private REST_API_SERVER = 'http://localhost:8081';
  private httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' }),
  };
  constructor(private httpClient: HttpClient) {}
  private handleError(error: HttpErrorResponse) {
    return throwError(error.error['message']);
  }


  // 1 GET
  //  /api/homestay/homestay-list findHomestayList
  public getHomestayByStatus(status: string) {
    this.httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json ',
        'Authorization': 'Bearer ' + localStorage.getItem('userToken'),
      }),
    };
    const url = `${this.REST_API_SERVER}/api/homestay/homestay-list?filter=HOMESTAY_STATUS&isNextPage=true&isPreviousPage=true&page=0&param=${status}&size=1000`;
    return this.httpClient
      .get<any>(url, this.httpOptions)
      .pipe(catchError(this.handleError));
  }

  public getHomestayByLandlord(username: any) {
    this.httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json ',
        'Authorization': 'Bearer ' + localStorage.getItem('userToken'),
      }),
    };
    const url = `${this.REST_API_SERVER}/api/homestay/homestay-list?filter=HOMESTAY_OWNER&isNextPage=true&isPreviousPage=true&page=0&param=${username}&size=100`;
    return this.httpClient
      .get<any>(url, this.httpOptions)
      .pipe(catchError(this.handleError));
  }

  public getHomestayByBlocHomestay(name: any) {
    this.httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json ',
        'Authorization': 'Bearer ' + localStorage.getItem('userToken'),
      }),
    };
    const url = `${this.REST_API_SERVER}/api/homestay/homestay-list?filter=HOMESTAY_BLOC&isNextPage=true&isPreviousPage=true&page=0&param=${name}&size=100`;
    return this.httpClient
      .get<any>(url, this.httpOptions)
      .pipe(catchError(this.handleError));
  }

  // 2 POST
  // /api/homestay/new-bloc  createBloc
  public createBloc(data:any){
    this.httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json ',
        'Authorization': 'Bearer ' + localStorage.getItem('userToken'),
      }),
    };
    const url = `${this.REST_API_SERVER}/api/homestay/new-bloc`;
  return this.httpClient
    .post<any>(url, data, this.httpOptions)
    .pipe(catchError(this.handleError));
  }

  // 3 POST
  // /api/homestay/new-homestay
  public createHomestay(
    name: string,
    address: string,
    availableRooms: string,
    businessLicense: string,
    homestayImages: Array<any>,
    homestayServices: Array<any>,
    homestayFacilities: Array<any>,
    price: string,
    roomCapacity:number,
    homestayRules: Array<any>
  ) {
    var value = {
      address,
      availableRooms,
      businessLicense,
      homestayFacilities,
      homestayImages,
      homestayRules,
      homestayServices,
      name,
      price,
      roomCapacity
    };
    let httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + localStorage.getItem('userToken'),
      })
    }
    console.log(value);
    const url = `${this.REST_API_SERVER}/api/homestay/new-homestay`;
    return this.httpClient
      .post<any>(url, value, httpOptions)
      .pipe(catchError(this.handleError));
  }

  // 4 GET
  // /api/homestay/user/bloc-list
public findBlocList(status:string){
  this.httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json ',
      'Authorization': 'Bearer ' + localStorage.getItem('userToken'),
    }),
  };
  const url = `${this.REST_API_SERVER}/api/homestay/user/bloc-list?isNextPage=true&isPreviousPage=true&page=0&size=1000&status=${status}`;
  return this.httpClient
    .get<any>(url, this.httpOptions)
    .pipe(catchError(this.handleError));
}

// 5 GET
//  /api/homestay/user/detail
public findHomestayByName(name:string){
  this.httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json ',
      'Authorization': 'Bearer ' + localStorage.getItem('userToken'),
    }),
  };
  const url = `${this.REST_API_SERVER}/api/homestay/user/detail?name=${name}`;
  return this.httpClient
    .get<any>(url, this.httpOptions)
    .pipe(catchError(this.handleError));
}

}
