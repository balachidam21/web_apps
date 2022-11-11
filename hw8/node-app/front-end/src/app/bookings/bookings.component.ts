import { Component, OnInit } from '@angular/core';
import { WebstorageService, Booking } from '../webstorage.service';
import { BehaviorService } from '../behavior.service';




@Component({
  selector: 'app-bookings',
  templateUrl: './bookings.component.html',
  styleUrls: ['./bookings.component.css']
})
export class BookingsComponent implements OnInit {

  bookingDetails: Booking[] = [];
  showBookings: Boolean = false;
  constructor(private webstorage: WebstorageService, private behavior: BehaviorService) {
    
   }
   

  ngOnInit(): void {
    this.webstorage.bookingObs.subscribe(data => {
      this.bookingDetails = data;
    });
    this.behavior.bookingObs.subscribe(data => {
      this.showBookings = data;
    });

    if(this.bookingDetails != null && this.bookingDetails.length > 0){
      this.behavior.updateBooking(true);
    }
    else{
      this.behavior.updateBooking(false);
    }

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
    if(this.bookingDetails.length == 0){
      this.behavior.updateBooking(false);
    }
  }

}
