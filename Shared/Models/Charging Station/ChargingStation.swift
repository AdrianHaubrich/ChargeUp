//
//  ChargingStation.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 14.11.21.
//

import Foundation
import CoreLocation
import MapKit
import Prometheus

struct ChargingStation: Identifiable {

    let id: String
    let ownerID: String
    
    // Placemark
    var location: Location?
    var annotation: MKPointAnnotation
    // var link
    
    // Charging Data
    // price
    // kw
    // charging-ports
    
    
    // TODO: Create from CLPlacemark
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, ownerID: String, location: Location? = nil) {
        
        // TODO: Title needs to be unique... -> identify by combination of title and coordinate -> secure: check with backend if existing and add number: e.g. Title #1
        
        // Identifiable
        self.id = UUID().uuidString
        self.ownerID = ownerID
        
        // Annotation
        self.annotation = MKPointAnnotation()
        self.annotation.title = title
        self.annotation.subtitle = subtitle
        self.annotation.coordinate = coordinate
        
        // Location
        if let location = location {
            self.location = location
        }
        
    }
    
}


// MARK: - Equatable
extension ChargingStation: Equatable {
    
    static func == (lhs: ChargingStation, rhs: ChargingStation) -> Bool {
        return lhs.id == rhs.id
    }
    
}


// MARK: - Codable
extension ChargingStation: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID
        case title
        case subtitle
        case longitude
        case latitude
        case name
        case adress
    }
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // MARK: Force decoding
        self.id = try values.decode(String.self, forKey: .id)
        self.ownerID = try values.decode(String.self, forKey: .ownerID)
        
        // MARK: Safe decoding (not optional!)
        self.annotation = MKPointAnnotation()
        
        // Title
        guard let title = try? values.decode(String.self, forKey: .title) else {
            let error = ChargingStationError.unableToDecodeTitle
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            throw error
        }
        self.annotation.title = title
        
        // Longitude
        guard let longitude = try? values.decode(Double.self, forKey: .longitude) else {
            let error = ChargingStationError.unableToDecodeLongitude
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            throw error
        }
        
        // Latitude
        guard let latitude = try? values.decode(Double.self, forKey: .latitude) else {
            let error = ChargingStationError.unableToDecodeLatitude
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            throw error
        }
        
        // Coordinate (from longitude & latitude)
        self.annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // MARK: Optional decoding
        // Subtitle
        if let subtitle = try? values.decode(String.self, forKey: .subtitle) {
            self.annotation.subtitle = subtitle
        }
        
        // Location
        guard let nameOfLocation = try? values.decode(String.self, forKey: .name) else {
            return
        }
        self.location = LocationManagerLocation(name: nameOfLocation, coordinate: self.annotation.coordinate)
        
        guard let adress = try? values.decode(String.self, forKey: .adress) else {
            return
        }
        self.location = LocationManagerLocation(name: nameOfLocation, address: adress, coordinate: self.annotation.coordinate)
        
    }
    
    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // MARK: Force encoding
        try container.encode(self.id, forKey: .id)
        try container.encode(self.ownerID, forKey: .ownerID)
        try container.encode(self.annotation.coordinate.longitude, forKey: .longitude)
        try container.encode(self.annotation.coordinate.latitude, forKey: .latitude)
        
        // MARK: Safe / optional endocing
        if let title = self.annotation.title {
            try container.encode(title, forKey: .title)
        }
        
        if let subtitle = self.annotation.subtitle {
            try container.encode(subtitle, forKey: .subtitle)
        }
        
        // Location
        if let nameOfLocation = self.location?.name {
            try container.encode(nameOfLocation, forKey: .name)
        }
        
        if let address = self.location?.address {
            try container.encode(address, forKey: .adress)
        }
        
    }
    
}


struct ChargingStationMock {
    
    static func generateChargingStation(_ station: Int) -> ChargingStation {
        switch station {
            case 1:
            return ChargingStation(title: "Charging Station 1", subtitle: "A great charging station.", coordinate: CLLocationCoordinate2D(latitude: 48.707049, longitude: 9.220510), ownerID: "ownerID")
            case 2:
                return ChargingStation(title: "Charging Station 2", subtitle: "A great charging station.", coordinate: CLLocationCoordinate2D(latitude: 48.718049, longitude: 9.220510), ownerID: "ownerID")
            case 3:
                return ChargingStation(title: "Charging Station 3", subtitle: "A great charging station.", coordinate: CLLocationCoordinate2D(latitude: 48.727049, longitude: 9.222510), ownerID: "ownerID")
            case 4:
                return ChargingStation(title: "Charging Station 4", subtitle: "A great charging station.", coordinate: CLLocationCoordinate2D(latitude: 48.737049, longitude: 9.223510), ownerID: "ownerID")
            case 5:
                return ChargingStation(title: "Charging Station 5", subtitle: "A great charging station.", coordinate: CLLocationCoordinate2D(latitude: 48.748049, longitude: 9.223510), ownerID: "ownerID")
            default:
                return ChargingStation(title: "Charging Station", subtitle: "A great charging station.", coordinate: CLLocationCoordinate2D(latitude: 48.707049, longitude: 9.220510), ownerID: "ownerID")
        }
    }
    
}
