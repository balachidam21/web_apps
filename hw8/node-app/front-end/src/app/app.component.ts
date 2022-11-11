import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'YelpAngularHw8';
  selected_search: boolean = true;
  selected_bookings: boolean = false;

  searchClick() {
    this.selected_search = true;
    this.selected_bookings = false;
  }
  bookingClick(){
    this.selected_search = false;
    this.selected_bookings = true;
  }
}
