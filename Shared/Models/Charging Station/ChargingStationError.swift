//
//  ChargingStationError.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 18.11.21.
//

import Foundation

enum ChargingStationError: String, Error {
    case stationNotFound = "Station not found."
    
    case unableToDecodeTitle = "Unable to decode title."
    case unableToDecodeSubtitle = "Unable to decode subtitle."
    case unableToDecodeLongitude = "Unable to decode longitude."
    case unableToDecodeLatitude = "Unable to decode latitude."
}
