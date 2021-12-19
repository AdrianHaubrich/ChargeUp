//
//  RouteViewModel.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 19.12.21.
//

import Foundation
import Prometheus

class RouteViewModel: ViewModel {
    
    // State
    @Published private(set) var state: RouteState
    
    // Services
    
    // Init
    init(route: Route) {
        self.state = RouteState(route: route)
    }
    
}


// MARK: - Fetch
extension RouteViewModel {
    
}


// MARK: - Upload
extension RouteViewModel {
    
}


// MARK: - Select Current Station
extension RouteViewModel {
    
    func selectCurrentStation(_ station: ChargingStation) {
        
        // Find Index of station
        let routeElementIndex = self.state.route.elements.firstIndex { element in
            if let elementStation = element.station {
                let s = elementStation.id == station.id
                return s
            }
            print("Station not found.")
            return false
        }
        
        DispatchQueue.main.async {
            if let routeElementIndex = routeElementIndex {
                
                var i = 0
                while i < self.state.route.elements.count {
                    
                    if i < routeElementIndex {
                        self.state.route.elements[i].state = .done
                    } else if i == routeElementIndex {
                        self.state.route.elements[i].state = .current
                    } else {
                        self.state.route.elements[i].state = .pending
                    }
                    
                    i += 1
                }
                
                // Set all stations before as done
                while i < routeElementIndex {
                    self.state.route.elements[i].state = .done
                    i += 1
                }
                
                // Set station as current
                self.state.route.elements[routeElementIndex].state = .current
                i += 1
                
                // Set all stations after as pending
                while i < self.state.route.elements.count {
                    self.state.route.elements[i].state = .pending
                    i += 1
                }
                
            }
        }
        
    }
    
}


// MARK: - Trigger
extension RouteViewModel {
    
    func trigger(_ input: RouteInput) {
        switch input {
        case .selectCurrentStation(let station):
            self.selectCurrentStation(station)
        }
    }
    
}
