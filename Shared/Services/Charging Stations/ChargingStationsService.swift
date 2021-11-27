//
//  ChargingStationsService.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 27.11.21.
//

import Combine

protocol ChargingStationsService {
    
    var type: ChargingStationsServiceType { get }
    
    // MARK: User
    var currentUserID: String { get }
    
    // MARK: Fetch
    func fetchStation(by stationID: String) async -> ChargingStation?
    func fetchNextStations(by creatorID: String, limit: Int?) async -> [ChargingStation]?
    // TODO: Fetch by geoHash: https://firebase.google.com/docs/firestore/solutions/geoqueries?hl=en
    
    // MARK: Listen
    
    // MARK: Create
    
}
