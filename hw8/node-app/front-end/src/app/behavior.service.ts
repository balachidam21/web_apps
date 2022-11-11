import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class BehaviorService {
  private searchBehavior = new BehaviorSubject<boolean>(false);
  private detailBehavior = new BehaviorSubject<boolean>(false);
  private bookingBehavior = new BehaviorSubject<boolean>(false);
  private reserveBehavior = new BehaviorSubject<boolean>(true);

  searchObs = this.searchBehavior.asObservable();
  detailObs = this.detailBehavior.asObservable();
  bookingObs = this.bookingBehavior.asObservable();
  reserveObs = this.reserveBehavior.asObservable();

  updateSearch(bool:any){
    this.searchBehavior.next(bool);
  }
  updateDetail(bool:any){
    this.detailBehavior.next(bool);
  }
  updateBooking(bool:any){
    this.bookingBehavior.next(bool);
  }
  updateReserve(bool:any){
    this.reserveBehavior.next(bool);
  }
  constructor() { }
}
