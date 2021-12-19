//
//  HomeInput.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 27.11.21.
//

import Foundation
import MapKit

enum HomeInput {
    
    // MARK: Local
    case setStationToPresent(station: ChargingStation)

    // MARK: Networking
    // Fetch
    case fetchStations
    case fetchStationsLazily(currentStation: ChargingStation)
    
    //Upload
    case createStation(station: ChargingStation)
    
}
