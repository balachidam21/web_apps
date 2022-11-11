import { Component, OnInit, Input, ViewChild } from '@angular/core';
import { Business } from '../interface';
import { YelpService } from '../yelp.service';
import { lastValueFrom , take} from 'rxjs';
import { BusinessDetail } from '../interface';
import { BehaviorService } from '../behavior.service';

@Component({
  selector: 'app-business-table',
  templateUrl: './business-table.component.html',
  styleUrls: ['./business-table.component.css']
})

export class BusinessTableComponent implements OnInit {
  @Input() businessList:Business[] = [];
  detail: BusinessDetail | undefined;
  showDetails: boolean = false;
  constructor(private yelpService: YelpService, public behaviour: BehaviorService) { }

  ngOnInit(): void {
    this.behaviour.detailObs.subscribe(data => {
      this.showDetails = data;
    });
    this.behaviour.updateDetail(false);
  }
  async getBusinessDetails(id:any){
    var d:any;
    var a:any;
    var s = this.yelpService.getBusinessDetails(id).pipe(take(1));
    d = await lastValueFrom(s);
    // console.log(d);
    var r = this.yelpService.getReviews(id);
    a = await lastValueFrom(r);
    // console.log(a);
    var category,is_open_now,phone,coordinates,location,photos,price,url;
    if(d.hasOwnProperty("categories") && d["categories"].length > 0)
    {var cat = [];
    for(let c of d["categories"]){
      cat.push(c['title']);
      category = cat.join(" | ");}
    }
    else{
      category = "NA";
    }
    if(d.hasOwnProperty("coordinates")){
      coordinates = d["coordinates"];
    }
    else{
      coordinates = "NA";
    }
    if(d.hasOwnProperty("hours") && d["hours"][0].is_open_now != null){
      is_open_now = d["hours"][0].is_open_now;
    }
    else{
      is_open_now = "NA";
    }
    if(d.hasOwnProperty("display_phone") && d["display_phone"] != "")
    {
      phone = d["display_phone"];
    }
    else{
      phone = "NA";
    }
    if(d.hasOwnProperty("location")){
      location = d["location"].display_address.join(" ");
    }
    else{
      location = "NA";
    }
    if(d.hasOwnProperty("photos") && d["photos"].length > 0)
    {
      photos = d["photos"]
    }
    else{
      photos = "NA";
    }
    if(d.hasOwnProperty("price") && d.price != ""){
      price = d["price"];
    }
    else{
      price = "NA";
    }
    if(d.hasOwnProperty("url") && d.url != ""){
      url = d["url"];
    }
    else{
      url = "NA"
    }
    this.detail = {
      name:d["name"],
    id:d["id"],
    category: category,
    coordinates: coordinates,
    phone: phone,
    is_open_now: is_open_now,
    location: location,
    photos: photos,
    price: price,
    url: url,
    reviews: a["reviews"]

    }
    this.yelpService.putBusinessDetails(this.detail);
    this.behaviour.updateSearch(false);
    this.behaviour.updateDetail(true);

  }
}
