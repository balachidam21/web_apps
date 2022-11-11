import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { BusinessDetail } from './interface';

@Injectable({
  providedIn: 'root'
})
export class YelpService {

  constructor(private http: HttpClient) { }

  rootURL = '/yelp';
  private businessDetail = new BehaviorSubject<any>({});
  businessObs = this.businessDetail.asObservable();
  getSearch(keyword:string,latitude:any,longitude:any,categories:string,radius:any){
    var url = this.rootURL + '/search';
    if(typeof(keyword)=='object'){
      keyword=keyword['text'];
    }
    // console.log(keyword,latitude,longitude,categories,radius);

    let queryParams = new HttpParams();
    queryParams = queryParams.append("keyword",keyword);
    queryParams = queryParams.append("latitude",latitude);
    queryParams = queryParams.append("longitude",longitude);
    queryParams = queryParams.append("categories",categories);
    queryParams = queryParams.append("radius",radius);

    return this.http.get(url, {params:queryParams});

  }

  getAutocompleteSuggestions(text:any){
    var url = this.rootURL + '/autocomplete'

    let queryParams = new HttpParams();
    queryParams = queryParams.append("text", text);

    return this.http.get(url, {params:queryParams});
  }

  getBusinessDetails(business_id:any){
    var url = this.rootURL + '/business'

    let queryParams = new HttpParams();
    queryParams = queryParams.append("business_id", business_id);

    return this.http.get(url, {params: queryParams});
  }
  getReviews(business_id: any){
    var url =  this.rootURL + '/reviews';

    let queryParams = new HttpParams();
    queryParams = queryParams.append("business_id", business_id);

    return this.http.get(url, {params: queryParams});
  }

  putBusinessDetails(bdetail:BusinessDetail){
    this.businessDetail.next(bdetail);
  }

}
