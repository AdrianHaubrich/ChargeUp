//
//  HomeState.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 27.11.21.
//

import Foundation
import MapKit

struct HomeState {
    
    var ownerID: String
    
    var chargingStations: [ChargingStation] = []

    var currentCenter: CLLocationCoordinate2D?
    var stationToPresent: ChargingStation?
    
}
