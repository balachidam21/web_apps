import { Injectable } from '@angular/core';
function getStorage(): Storage{
  return localStorage;
}
@Injectable({
  providedIn: 'root'
})
export class SessionstorageService {

  constructor() { }
  getSessionStorage(): Storage{
    return getStorage();
  }
}
