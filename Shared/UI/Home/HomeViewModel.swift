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
    private let stationsService: ChargingStationsService
    
    // Init
    init(stationsService: ChargingStationsService) {
        self.state = HomeState(ownerID: stationsService.currentUserID)
        self.stationsService = stationsService
    }
    
}


// MARK: - Fetch
extension HomeViewModel {
    
    private func fetchStations() {
        Task.detached {
            
            // Fetch new Stations
            let newStations = await self.stationsService.fetchNextStations(by: self.state.ownerID, limit: 5)
            
            // Update State
            if let newStations = newStations {
                DispatchQueue.main.async {
                    // self.state.chargingStations.append(contentsOf: newStations)
                    self.reduceStations(newStations: newStations)
                }
            }
        }
    }
    
    private func reduceStations(newStations: [ChargingStation]) {
        
        // Replace existing Stations
        for newStation in newStations {
            if let index = self.state.chargingStations.firstIndex(where: { $0 == newStation }) {
                // Station already loaded / exists locally
                self.state.chargingStations[index] = newStation
            } else {
                // Add new station
                self.state.chargingStations.append(newStation)
            }
        }
        
    }
    
}


// MARK: - Upload
extension HomeViewModel {
    
    private func createStation(_ station: ChargingStation) {
        Task.detached {
            try await self.stationsService.createStation(station)
            DispatchQueue.main.async {
                self.state.chargingStations.append(station)
            }
        }
    }
    
}


// MARK: - Trigger
extension HomeViewModel {
    
    func trigger(_ input: HomeInput) {
        switch input {
        case .setStationToPresent(let station):
            self.state.stationToPresent = station
            
        case .createStation(let station):
            self.createStation(station)
            
        case .fetchStations:
            self.fetchStations()
            
        case .fetchStationsLazily(currentStation: let currentStation):
            if currentStation == self.state.chargingStations.last {
                self.fetchStations()
            }
        }
    }
    
}
