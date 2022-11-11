import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { SessionstorageService } from './sessionstorage.service';
@Injectable({
  providedIn: 'root'
})

export class WebstorageService {
  private localStorage: Storage | any;
  constructor(private session: SessionstorageService ) {
    this.localStorage = session.getSessionStorage() ;
    this.loadBooking();
   }
   private bookings = new BehaviorSubject([]);
   bookingObs = this.bookings.asObservable();

   setBooking(data:any)
   {
    const jsonData = JSON.stringify(data);
    // console.log(jsonData);
    this.localStorage.setItem('bookings', jsonData);
    this.bookings.next(data);
   }
   loadBooking(){
    const data = JSON.parse(this.localStorage.getItem('bookings'));
    this.bookings.next(data);
   }
}
export interface Booking{
  business_name: any,
  email: any,
  hour:any,
  minute:any,
  date:any

}