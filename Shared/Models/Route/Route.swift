//
//  Route.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 18.12.21.
//

import Foundation
import MapKit

struct Route: Identifiable {
    
    let id: String
    let ownerID: String
    
    var title: String
    var elements: [RouteElement]
    
    
    init(title: String, stations: [ChargingStation], ownerID: String) {
        
        self.id = UUID().uuidString
        self.ownerID = ownerID
        
        self.title = title
        
        // Map stations to elements
        self.elements = []
        self.elements = stations.map {
            RouteElement(state: .pending, station: $0, ownerID: ownerID, routeID: self.id)
        }
        
        // Set first element as current
        if elements.count > 0 {
            self.elements[0].state = .current
        }
        
    }
    
    // Demo Scenario
    init(ownerID: String) {
        
        // Stations
        let stations = [
            ChargingStation(title: "Demo 1", subtitle: "Todo", coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 10), ownerID: ownerID),
            ChargingStation(title: "Demo 2", subtitle: "Todo", coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 10), ownerID: ownerID)
        ]
        
        // Init
        self.init(title: "Demo Title", stations: stations, ownerID: ownerID)
        
    }
    
}

// MARK: - Equatable
extension Route: Equatable {
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.id == rhs.id
    }
    
}


// MARK: - Codable
extension Route: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID
        case title
    }
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // MARK: Force decoding
        self.id = try values.decode(String.self, forKey: .id)
        self.ownerID = try values.decode(String.self, forKey: .ownerID)
        
        // MARK: Safe decoding (not optional!)
        guard let title = try? values.decode(String.self, forKey: .title) else {
            let error = RouteError.unableToDecodeTitle
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            throw error
        }
        self.title = title
        
        // Elements
        self.elements = []
        
    }
    
    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // MARK: Force encoding
        try container.encode(self.id, forKey: .id)
        try container.encode(self.ownerID, forKey: .ownerID)
        try container.encode(self.title, forKey: .title)
        
    }
    
}
