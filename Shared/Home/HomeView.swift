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
    
    @StateObject var locationManager = LocationManager()
    @State var isBottomSheetOpen = true
    
    @State var chargingStations: [ChargingStation] = [
        ChargingStationMock.generateChargingStation(1),
        ChargingStationMock.generateChargingStation(2),
        ChargingStationMock.generateChargingStation(3),
        ChargingStationMock.generateChargingStation(4),
        ChargingStationMock.generateChargingStation(5)
    ]
    
    @State var currentCenter: CLLocationCoordinate2D?
    @State var isPresentingDetail = false
    @State var isPresentingCreation = false
    @State var stationToPresent: ChargingStation?
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: Fix
            if let stationToPresent = stationToPresent {
                Text(stationToPresent.id).frame(width: 0, height: 0)
            }
            
            // MARK: Map with annotation
            if let currentCenter = self.currentCenter ?? self.locationManager.lastLocation?.coordinate {
                // TODO: Center as binding that gets updated on change..., or only get once...
                HelenaMapView(centerCoordinate: currentCenter,
                              annotations: self.chargingStations.map {
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
                    self.stationToPresent = station
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
                    ForEach(self.chargingStations) { station in
                        ChargingStationCard(station: station) { station in
                            // Center Map to Station
                            // self.currentCenter = station.annotation.coordinate
                            
                            // Present Station
                            self.stationToPresent = station
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
            if let stationToPresent = stationToPresent {
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

extension HomeView {
    
    func getStationByAnnotation(_ annotation: MKAnnotation) throws -> ChargingStation {
        for station in self.chargingStations {
            if station.annotation.title == annotation.title {
                return station
            }
        }
        throw ChargingStationError.stationNotFound
    }
    
    func createStation(_ station: ChargingStation) {
        self.chargingStations.append(station)
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
        HomeView()
    }
}
