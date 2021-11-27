//
//  FirestoreChargingStationsService.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 27.11.21.
//

import Foundation
import Combine
import SwiftUI
import PrometheusFirestore
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreChargingStationsService: ChargingStationsService {
    
    var type: ChargingStationsServiceType
    var currentUserID: String
    
    // Lazy Fetching - Pointer for next fetch
    var lastStationByCreatorDoc: DocumentSnapshot?
    
    // MARK: Init
    init(currentUserID: String) {
        self.type = .firestore
        self.currentUserID = currentUserID
    }
    
}


// MARK: - Fetch
extension FirestoreChargingStationsService {
    
    func fetchStation(by stationID: String) async -> ChargingStation? {
        do {
            
            let doc = try await FirestoreChargingStationsReferenceFactory
                .generateStationReference(by: stationID)
                .getDocument()
                .data(as: ChargingStation.self)
            
            guard let station = doc else {
                throw FirestoreChargingStationsServiceError.unableToFetchStation
            }
            
            return station
            
        } catch {
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            return nil
        }
    }
    
    func fetchNextStations(by creatorID: String,
                           limit: Int?) async -> [ChargingStation]? {
        do {
            
            let snapshot = try await FirestoreChargingStationsReferenceFactory
                .generateStationsQuery(by: creatorID, with: limit, start: self.lastStationByCreatorDoc)
                .getDocuments()
            
            // Set Pointer for next fetch
            self.lastStationByCreatorDoc = snapshot.documents.last
            
            // TODO: Unsafe
            let stations = try snapshot.documents.map {
                try $0.data(as: ChargingStation.self)!
            }
            
            return stations
            
        } catch {
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            return nil
        }
    }
    
}


// MARK: - Create
extension FirestoreChargingStationsService {
    // TODO: Create - add to protocol
}
