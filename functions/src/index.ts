import {initializeApp} from "firebase-admin/app";
import {setGlobalOptions} from "firebase-functions/v2";
import {
  approveBooking,
  cancelBooking,
  completeBooking,
  createBooking,
} from "./bookingFunctions.js";

initializeApp();

setGlobalOptions({maxInstances: 10});

export {
  createBooking,
  approveBooking,
  cancelBooking,
  completeBooking,
};

