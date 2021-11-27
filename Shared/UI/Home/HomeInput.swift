//
//  HomeInput.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 27.11.21.
//

import Foundation
import MapKit

enum HomeInput {
    case setStationToPresent(station: ChargingStation)
    case createStation(station: ChargingStation)
}
