//
//  RouteElement.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 19.12.21.
//

import Foundation

struct RouteElement: Identifiable {
    
    let id: String
    let ownerID: String
    let routeID: String
    
    var state: RouteElementState
    
    var stationID: String
    var station: ChargingStation?
    
    init(state: RouteElementState, station: ChargingStation, ownerID: String, routeID: String) {
        
        self.init(state: state, stationID: station.id, ownerID: ownerID, routeID: routeID)
        self.station = station
    }
    
    init(state: RouteElementState, stationID: String, ownerID: String, routeID: String) {
        
        self.id = UUID().uuidString
        self.ownerID = ownerID
        self.routeID = routeID
        
        self.state = state
        self.stationID = stationID
    }
    
}


// MARK: - Equatable
extension RouteElement: Equatable {
    
    static func == (lhs: RouteElement, rhs: RouteElement) -> Bool {
        return lhs.id == rhs.id
    }
    
}


// MARK: - Codable
extension RouteElement: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID
        case routeID
        case stationID
        case state
    }
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // MARK: Force decoding
        self.id = try values.decode(String.self, forKey: .id)
        self.ownerID = try values.decode(String.self, forKey: .ownerID)
        self.routeID = try values.decode(String.self, forKey: .routeID)
        self.stationID = try values.decode(String.self, forKey: .stationID)
        
        // MARK: Safe decoding
        guard let stateString = try? values.decode(String.self, forKey: .state) else {
            let error = RouteError.unableToDecodeState
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            throw error
        }
        guard let state = RouteElementState(rawValue: stateString) else {
            let error = RouteError.invalidState
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            throw error
        }
        self.state = state
        
    }
    
    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // MARK: Force encoding
        try container.encode(self.id, forKey: .id)
        try container.encode(self.ownerID, forKey: .ownerID)
        try container.encode(self.routeID, forKey: .routeID)
        try container.encode(self.stationID, forKey: .stationID)
        try container.encode(self.state.rawValue, forKey: .state)
        
    }
    
}
