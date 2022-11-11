import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import config from '../assets/json/config.json';
import { Observable } from 'rxjs';
@Injectable({
  providedIn: 'root'
})
export class LocationService {
  
  constructor(private http: HttpClient) { }
  
  ipInfoURL = "https://ipinfo.io/?token="+config.IPINFO_TOKEN;
  geoCodeURL = "https://maps.googleapis.com/maps/api/geocode/json?address=";
  getIPINFO() {
    return this.http.get(this.ipInfoURL);
  }
  getGeoCode(location:any){
    var url = this.geoCodeURL + location + "&key=" + config.GEOCODE_API;
    // console.log(this.geoCodeURL);
    return this.http.get(url); 
  }
}
