//
//  FirestoreChargingStationsServiceError.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 27.11.21.
//

import Foundation

enum FirestoreChargingStationsServiceError: String, Error {
    case unableToFetchStation = "Unable to fetch station."
    case unableToCreateStation = "Unable to create station."
}
