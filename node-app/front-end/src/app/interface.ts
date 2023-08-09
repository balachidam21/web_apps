export interface Business{
    name:any;
    id:any;
    rating:any;
    distance:any;
    image_url:any;
  }

  export interface BusinessDetail {
    name:any,
    id:any,
    category: any,
    coordinates: {
      latitude:any,
      longitude:any
    },
    phone: any,
    is_open_now: any,
    location: any,
    photos: any,
    price: any,
    url: any,
    reviews: any
  }