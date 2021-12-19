//
//  FirestoreRouteReferenceFactory.swift
//  ChargeUp
//
//  Created by Adrian Haubrich on 19.12.21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Prometheus

struct FirestoreRouteReferenceFactory {
    
    // Constants
    static let PATH_TO_ROUTES = "routes"
    static let PATH_TO_ELEMENTS = "routeElements"
    
}


// MARK: - Route
extension FirestoreRouteReferenceFactory {
    
    static func generateRouteReference(by routeID: String) -> DocumentReference {
        return Firestore.firestore()
            .collection(self.PATH_TO_ROUTES)
            .document(routeID)
    }
    
    static func generateRoutesQuery(by creatorID: String,
                                    with limit: Int?,
                                    start atDocument: DocumentSnapshot? = nil) -> Query {
        var query = Firestore.firestore()
            .collection(self.PATH_TO_ROUTES)
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


// MARK: - Route Element
extension FirestoreRouteReferenceFactory {
    
    static func generateRouteElementReference(by elementID: String) -> DocumentReference {
        return Firestore.firestore()
            .collection(self.PATH_TO_ELEMENTS)
            .document(elementID)
    }
    
    static func generateRouteElementsQuery(by routeID: String,
                                           with limit: Int?,
                                           start atDocument: DocumentSnapshot? = nil) -> Query {
        var query = Firestore.firestore()
            .collection(self.PATH_TO_ELEMENTS)
            .whereField("routeID", isEqualTo: routeID)
        
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
