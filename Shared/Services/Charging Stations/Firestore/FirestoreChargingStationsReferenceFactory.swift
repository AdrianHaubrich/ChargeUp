//
//  FirestoreChargingStationsReferenceFactory.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 27.11.21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Prometheus

struct FirestoreChargingStationsReferenceFactory {
    
    // Constants
    static let PATH_TO_STATIONS = "chargingStations"
    
}


// MARK: - Fetch
extension FirestoreChargingStationsReferenceFactory {
    
    static func generateStationReference(by stationID: String) -> DocumentReference {
        return Firestore.firestore()
            .collection(self.PATH_TO_STATIONS)
            .document(stationID)
    }
    
    static func generateStationsQuery(by creatorID: String,
                                      with limit: Int?,
                                      start atDocument: DocumentSnapshot? = nil) -> Query {
        var query = Firestore.firestore()
            .collection(self.PATH_TO_STATIONS)
            .whereField("ownerID", isEqualTo: creatorID)
        
        if let limit = limit {
            query = query
                .limit(to: limit)
        }
        
        if let atDocument = atDocument {
            query = query
                .start(atDocument: atDocument)
        }
        
        return query
    }
    
}
