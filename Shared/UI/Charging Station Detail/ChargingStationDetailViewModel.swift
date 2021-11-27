//
//  ChargingStationDetailViewModel.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 27.11.21.
//

import Foundation
import Prometheus

class ChargingStationDetailViewModel: ViewModel {
    
    // State
    @Published private(set) var state: ChargingStationDetailState
    
    // Services
    
    // Init
    init(station: ChargingStation) {
        self.state = ChargingStationDetailState(station: station)
    }
    
}


// MARK: - Trigger
extension ChargingStationDetailViewModel {
    
    func trigger(_ input: ChargingStationDetailInput) {}
    
}
