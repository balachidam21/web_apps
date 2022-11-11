import { Component, OnInit, Input, ViewChild } from '@angular/core';
import { BusinessDetail } from '../interface';
import { BehaviorService } from '../behavior.service';
import { YelpService } from '../yelp.service';
import { WebstorageService, Booking } from '../webstorage.service';
@Component({
  selector: 'app-business-details',
  templateUrl: './business-details.component.html',
  styleUrls: ['./business-details.component.css']
})
export class BusinessDetailsComponent implements OnInit {
  businessDetail: BusinessDetail | any;
  mapOptions:google.maps.MapOptions | any;
  marker:any;
  bookingDetails: Booking[] = [];
  constructor(public behaviour: BehaviorService, private yelpService: YelpService, private webstorage: WebstorageService) { }
  show: boolean = false;
  show_reservation:boolean = true;
  @ViewChild('closebutton') closebutton:any;

  goBack()
  { 
    // console.log("Inside");
    this.behaviour.updateDetail(false);
    this.behaviour.updateSearch(true);
  }
  ngOnInit(): void {
    this.behaviour.detailObs.subscribe(data => {
      this.show = data;
    });
    this.behaviour.reserveObs.subscribe(data => {
      this.show_reservation = data;
    })
    this.yelpService.businessObs.subscribe(data => {
      this.businessDetail = data;
      this.mapOptions = {
        center: { lat: this.businessDetail["coordinates"].latitude, lng: this.businessDetail["coordinates"].longitude  },
        zoom : 14
     };
     this.marker = {
        position: { lat: this.businessDetail["coordinates"].latitude, lng: this.businessDetail["coordinates"].longitude },

     };
    });
    this.webstorage.bookingObs.subscribe(data => {
      this.bookingDetails = data;
    });
    // console.log(this.bookingDetails);
    var form = document.getElementsByClassName('requires-validation')[0] as HTMLFormElement;
    form.reset();
  }
  getTodayDate()
  {
    var today = new Date().toLocaleDateString();
    var mm,dd,yyyy;
    var arr = today.split('/');
    if(parseInt(arr[0]) < 10){
      mm = '0' + arr[0]
    }
    else{
      mm = arr[0];
    }
    if(parseInt(arr[1]) < 10){
      dd = '0' + arr[1];
    }
    else{
      dd = arr[1];
    }
    yyyy = arr[2];
    const format = yyyy+'-'+mm+'-'+dd;
    return format;
  }

  async validate(event:any,name:any){
    var form = document.getElementsByClassName('requires-validation')[0] as HTMLFormElement;
    if (form.checkValidity() === false) {
      // console.log(form);
      event.preventDefault();
      event.stopPropagation();
    }
    form.classList.add('was-validated');
    var email = (<HTMLInputElement>document.getElementById('validationEmail')).value;
    var date = (<HTMLInputElement>document.getElementById('validationDate')).value;
    var hour = (<HTMLInputElement>document.getElementById('validationHour')).value;
    var min = (<HTMLInputElement>document.getElementById('validationMinute')).value;
    if(email != "" && date != "" && hour != "" && min != "" && date != ""){
      // console.log(this.bookingDetails);
      if(this.bookingDetails == null){
        this.bookingDetails = [];
      }
      // console.log(date);
      var current_booking: Booking = {
        business_name: name,
        email: email,
        hour: hour,
        minute: min,
        date: date
      }
      // console.log(this.bookingDetails);
      await this.bookingDetails.push(current_booking);
      // console.log(this.bookingDetails);
      await this.webstorage.setBooking(this.bookingDetails);
      this.behaviour.updateReserve(false);
      form.reset();
      form.classList.remove('was-validated');
      alert("Reservation created!");
      this.closebutton.nativeElement.click();
      
    }
  }
  checkReservation(name:any){
    if(this.bookingDetails != null && this.bookingDetails.length > 0){
    for(const b of this.bookingDetails){
      // console.log(b['business_name']);
      if(b['business_name'] == name)
      {
        return false;
      }
    }}
    return true;
  }
  async cancelReservation(name:any){
    var temp:any;
    for(const b of this.bookingDetails){
      if(b['business_name'] == name){
        temp = this.bookingDetails.indexOf(b);
        break;
      }
    }
    await this.bookingDetails.splice(temp,1)
    // console.log(this.bookingDetails);
    // this.bookingDetails.remove(temp);
    await this.webstorage.setBooking(this.bookingDetails);
    alert("Reservation cancelled!")
  }
  clearForm(){
    var form = document.getElementsByClassName('requires-validation')[0] as HTMLFormElement;
    // console.log(form);
    form.reset();
  }

}
