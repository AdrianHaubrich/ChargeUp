//
//  HomeState.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 27.11.21.
//

import Foundation
import MapKit

struct HomeState {
    
    var chargingStations: [ChargingStation] = [
        ChargingStationMock.generateChargingStation(1),
        ChargingStationMock.generateChargingStation(2),
        ChargingStationMock.generateChargingStation(3),
        ChargingStationMock.generateChargingStation(4),
        ChargingStationMock.generateChargingStation(5)
    ]

    var currentCenter: CLLocationCoordinate2D?
    var stationToPresent: ChargingStation?
    
}
