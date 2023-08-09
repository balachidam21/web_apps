import { Component, OnInit } from '@angular/core';
import { lastValueFrom, take } from 'rxjs';
import { FormControl } from '@angular/forms';
import { HttpClient } from '@angular/common/http';

import { LocationService } from '../location.service';
import { YelpService } from '../yelp.service';
import { Business } from '../interface';
import { BehaviorService } from '../behavior.service';
import { debounceTime, tap, switchMap, finalize, distinctUntilChanged, filter } from 'rxjs/operators';


@Component({
  selector: 'app-search-form',
  templateUrl: './search-form.component.html',
  styleUrls: ['./search-form.component.css']
})
export class SearchFormComponent implements OnInit {
  disableLoc: boolean = false;
  keyword: string = "";
  radius: any;
  category: string = "all";
  location: string = "";
  latitude: any;
  longitude: any
  showSearchResults: boolean = false;
  showNoResults: boolean = false;
  business_results: Business[] = [];

  searchKeywordCtrl = new FormControl();
  filteredSuggestions: any[] = [];
  isLoading = false;
  minLength = 2;



  constructor(private http: HttpClient, private locationService: LocationService, private yelpService: YelpService, public behaviour: BehaviorService) { }
  disableLocation() {
    // console.log("Clicked auto-detect!")
    this.disableLoc = !this.disableLoc;
    if (this.disableLoc) {
      this.location = "";
    }
  }

  onSelected() {
    // console.log(this.keyword);
    this.keyword = this.keyword;
  }

  displayWith(value: any) {
    return value?.text;
  }
  
  ngOnInit() {
    this.showNoResults = false;
    this.behaviour.searchObs.subscribe(data =>{
      this.showSearchResults = data;
    });
    this.searchKeywordCtrl.valueChanges
      .pipe(
        filter(res => {
          return res !== null && res.length >= this.minLength
        }),
        distinctUntilChanged(),
        debounceTime(1000),
        tap(() => {
          this.filteredSuggestions = [];
          this.isLoading = true;
        }),
        switchMap(value => this.yelpService.getAutocompleteSuggestions(value)
          .pipe(
            finalize(() => {
              this.isLoading = false
            }),
          )
        )
      )
      .subscribe((data: any) => {
        if (data['suggestions'] == undefined) {
          this.filteredSuggestions = [];
        } else {
          this.filteredSuggestions = data['suggestions'];
        }
        // console.log(this.filteredSuggestions);
      });
      this.behaviour.updateSearch(false);
      this.behaviour.updateDetail(false);
  }

  async onSubmit(event: any) {
    event.preventDefault();
    var d: any;
    if (this.radius == undefined) {
      this.radius = 10;
    }
    if (this.disableLoc) {
      // Call IpInfo
      // await this.locationService.getIPINFO().toPromise()
      // .then((data:any) => {
      //   let loc = data.loc;
      //   [this.latitude, this.longitude] = loc.split(",");
      // });
      d = this.locationService.getIPINFO().pipe(take(1));
      d = await lastValueFrom(d);
      let loc = d.loc;
      [this.latitude, this.longitude] = loc.split(",");
    }
    else {
      var loc = this.location.split(" ");
      var output = loc.join("+");
      // await this.locationService.getGeoCode(output).toPromise()
      // .then((data:any) => {
      //   if (data.status == "OK") {
      //     var loc = data.results[0].geometry.location;
      //     this.latitude = loc["lat"];
      //     this.longitude = loc["lng"];
      // }
      // });
      var data$ = this.locationService.getGeoCode(output).pipe(take(1));
      d = await lastValueFrom(data$);
      if (d.status == "OK") {
        var l = d.results[0].geometry.location;
        this.latitude = l["lat"];
        this.longitude = l["lng"];
      }
      else{
        this.behaviour.updateSearch(false);
        this.showNoResults = true;
        return;
      }
      // console.log(d);

    }
    // make a call to /yelp/search with the parameters
    // console.log(this.keyword, this.latitude, this.longitude, this.category, this.radius);
    var s = this.yelpService.getSearch(this.keyword, this.latitude, this.longitude, this.category, this.radius).pipe(take(1));
    d = await lastValueFrom(s);
    // console.log(d);
    this.business_results = [];
    
    if (d != undefined && d['total'] > 0) {
      for (const item of d["businesses"]) {
        var image_src;
        if (item.image_url == "") {
          image_src = "https://www.freepnglogos.com/uploads/yelp-logo-red-2.png";
        }
        else {
          image_src = item.image_url;
        }
        let temp: Business = {
          'id': item.id,
          'name': item.name,
          'distance': (item.distance / 1609.344).toFixed(1),
          'rating': item.rating,
          'image_url': image_src
        };
        this.business_results.push(temp);

      }
      this.behaviour.updateSearch(true);
      this.showNoResults = false;
    }
    else{
      this.behaviour.updateSearch(false);
      this.showNoResults = true;
    }
    // console.log(this.business_results);
  }
  clearButton(){
    this.behaviour.updateSearch(false);
    this.behaviour.updateDetail(false);
    this.showNoResults = false;
    this.disableLoc = false;
  }

}
