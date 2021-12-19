//
//  FirestoreRoutesService.swift
//  ChargeUp
//
//  Created by Adrian Haubrich on 19.12.21.
//

import Foundation
import Combine
import SwiftUI
import PrometheusFirestore
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreRoutesService: RoutesService {
    
    var type: RoutesServiceType
    var currentUserID: String
    
    // Lazy Fetching - Pointer for next fetch
    private var lastRouteByCreatorDoc: DocumentSnapshot?
    private var lastRouteElementByRouteDocs: [String : DocumentSnapshot] = [:]
    
    // MARK: Init
    init(currentUserID: String) {
        self.type = .firestore
        self.currentUserID = currentUserID
    }
    
}


// MARK: - Fetch
extension FirestoreRoutesService {
    
    func fetchNextRoutes(by creatorID: String, limit: Int?) async -> [Route]? {
        do {
            
            let snapshot = try await FirestoreRouteReferenceFactory
                .generateRoutesQuery(by: creatorID, with: limit, start: self.lastRouteByCreatorDoc)
                .getDocuments()
            
            // Set Pointer for next fetch
            self.lastRouteByCreatorDoc = snapshot.documents.last
            
            // TODO: Unsafe
            let routes = try snapshot.documents.map {
                try $0.data(as: Route.self)!
            }
            
            return routes
            
        } catch {
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            return nil
        }
    }
    
    func fetchNextRouteElements(by routeID: String, limit: Int?) async -> [RouteElement]? {
        do {
            
            let snapshot = try await FirestoreRouteReferenceFactory
                .generateRouteElementsQuery(by: routeID, with: limit, start: self.lastRouteElementByRouteDocs[routeID])
                .getDocuments()
            
            // Set Pointer for next fetch
            self.lastRouteElementByRouteDocs[routeID] = snapshot.documents.last
            
            // TODO: Unsafe
            let routeElements = try snapshot.documents.map {
                try $0.data(as: RouteElement.self)!
            }
            
            return routeElements
            
        } catch {
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            return nil
        }
    }
    
}


// MARK: - Update
extension FirestoreRoutesService {
    
    func updateRoute(_ route: Route) async throws -> Route {
        try await self.createRoute(route)
    }
    
}


// MARK: - Create
extension FirestoreRoutesService {
    
    func createRoute(_ route: Route) async throws -> Route {
        do {
            
            // Upload Route
            try FirestoreRouteReferenceFactory
                .generateRouteReference(by: route.id)
                .setData(from: route)
            
            return route
            
        } catch {
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            throw FirestoreRouteServiceError.unableToCreateRoute
        }
    }
    
}
