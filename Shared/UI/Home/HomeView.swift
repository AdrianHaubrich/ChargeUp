//  HomeView.swift
//
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 14.11.21.
//

import SwiftUI
import Helena
import Prometheus
import MapKit

struct HomeView: View {
    
    // View Model
    @ObservedObject var viewModel: AnyViewModel<HomeState, HomeInput>
    @StateObject var locationManager = LocationManager()
    
    // MARK: UI
    @State var isBottomSheetOpen = true
    @State var isPresentingDetail = false
    @State var isPresentingCreation = false
    
    // MARK: Body
    var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: Map with annotation
            if let currentCenter = self.viewModel.state.currentCenter ?? self.locationManager.lastLocation?.coordinate {
                HelenaMapView(centerCoordinate: currentCenter,
                              annotations: self.viewModel.state.chargingStations.map {
                    return $0.annotation
                }, isUserInteractionEnabled: true,
                              showUserLocation: true, showScale: true,
                              showCompass: true,
                              showTraffic: true,
                              showBuildings: true) { annotationView in
                    
                    // Annotation selected
                    guard let annotation = annotationView.annotation else {
                        return
                    }
                    guard let station = try? getStationByAnnotation(annotation) else {
                        return
                    }
                    
                    // Present Station
                    self.setStation(station)
                    self.isPresentingDetail.toggle()
                    
                }
                    .ignoresSafeArea()
                
                Text("Center: \(currentCenter.latitude) | \(currentCenter.longitude)")
            }
            
            // MARK: Bottom Sheet
            HelenaFullScreenBottomCard(isOpen: self.$isBottomSheetOpen, minHeight: 180, maxHeight: UIScreen.main.bounds.size.height) {
                
                // Actions
                HStack {
                    IconButton(systemName: "plus") {
                        self.isPresentingCreation.toggle()
                    }
                }
                .padding()
                
                // Charging Stations
                ScrollView {
                    ForEach(self.viewModel.state.chargingStations) { station in
                        ChargingStationCard(station: station) { station in
                            // Center Map to Station
                            // self.currentCenter = station.annotation.coordinate
                            
                            // Present Station
                            self.setStation(station)
                            self.isPresentingDetail.toggle()
                        }
                        .padding(5)
                    }.padding()
                }
            }
            .offset(x: 0, y: 25)
            
        }
        .ignoresSafeArea(edges: .bottom)
        
        // MARK: Detail
        .sheet(isPresented: $isPresentingDetail) {
            if let stationToPresent = self.viewModel.state.stationToPresent {
                CharginStationDetailView(station: stationToPresent)
            }
        }
        
        // MARK: Creation
        .sheet(isPresented: $isPresentingCreation) {
            CreateChargingStationView() { newStation in
                // Add Station
                self.createStation(newStation)
                
                // Hide Sheet
                self.isPresentingCreation = false
            }
        }
    }
    
}


// MARK: - Trigger
extension HomeView {
    
    func getStationByAnnotation(_ annotation: MKAnnotation) throws -> ChargingStation {
        for station in self.viewModel.state.chargingStations {
            if station.annotation.title == annotation.title {
                return station
            }
        }
        throw ChargingStationError.stationNotFound
    }
    
    func setStation(_ station: ChargingStation) {
        self.viewModel.trigger(.setStationToPresent(station: station))
    }
    
    func createStation(_ station: ChargingStation) {
        self.viewModel.trigger(.createStation(station: station))
    }
    
}



// TODO: Helena
struct TagText: View {
    
    let text: String
    
    var body: some View {
        Text(text)
            .padding(5)
            .background {
                RoundedRectangle(cornerRadius: HelenaLayout.cornerRadius).fill(Color.helenaBackgroundSmallAccent)
            }
    }
    
}

// TODO: Helena
struct IconButton: View {
    
    let systemName: String
    let onTap: () -> ()
    
    var body: some View {
        VStack {
            Image(systemName: systemName)
                .padding()
                .foregroundColor(Color.helenaTextLight)
                .background {
                    Circle().fill(Color.helenaTextAccent)
                }
        }.onTapGesture {
            self.onTap()
        }
    }
    
}


// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: AnyViewModel(HomeViewModel()))
    }
}
