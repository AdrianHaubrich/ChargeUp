//
//  HomeViewModel.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 27.11.21.
//

import Foundation
import Prometheus

class HomeViewModel: ViewModel {

    // State
    @Published private(set) var state: HomeState
    
    // Services
    
    
    // Init
    init() {
        self.state = HomeState()
    }
    
}

extension HomeViewModel {
    
    
    
}


// MARK: - Trigger
extension HomeViewModel {
    
    func trigger(_ input: HomeInput) {
        switch input {
            case .setStationToPresent(let station):
                self.state.stationToPresent = station
            
            case .createStation(let station):
                self.state.chargingStations.append(station)
        }
    }
    
}
