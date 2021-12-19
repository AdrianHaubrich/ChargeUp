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
    @State var selectedIndex: Int = 0
    
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
                
                // Text("Center: \(currentCenter.latitude) | \(currentCenter.longitude)")
            }
            
            // MARK: Bottom Sheet
            HelenaFullScreenBottomCard(isOpen: self.$isBottomSheetOpen, minHeight: 180, maxHeight: UIScreen.main.bounds.size.height) {
                
                // Picker
                HelenaRectPicker(selectedIndex: self.$selectedIndex, options: ["Routes", "Stations"])
                    .padding([.horizontal, .top])
                
                // Routes
                if selectedIndex == 0 {
                    ScrollView {
                        
                        // Actions
                        /*HStack {
                            IconButton(systemName: "plus") {
                                self.isPresentingCreation.toggle()
                            }
                        }
                        .padding(.top)*/
                        
                        // Route
                        // TODO: Routes instead of one route...
                        RouteView(viewModel: AnyViewModel(RouteViewModel(route: Route(ownerID: self.viewModel.ownerID))))
                        
                    }
                }
                
                // Charging Stations
                else if self.selectedIndex == 1 {
                    ScrollView {
                        
                        // Actions
                        HStack {
                            IconButton(systemName: "plus") {
                                self.isPresentingCreation.toggle()
                            }
                        }
                        .padding(.top)
                        
                        // Stations
                        ForEach(self.viewModel.state.chargingStations) { station in
                            LazyVStack {
                                ChargingStationCard(station: station, initialIsCollabsed: false) { station in
                                    // Center Map to Station
                                    // self.currentCenter = station.annotation.coordinate
                                    
                                    // Present Station
                                    self.setStation(station)
                                    self.isPresentingDetail.toggle()
                                } onMapSelection: {station in
                                    // Present Station
                                    self.setStation(station)
                                    self.isPresentingDetail.toggle()
                                }
                                .onAppear {
                                    self.fetchStationsLazily(currentStation: station)
                                }
                            }
                        }.padding()
                    }
                }
                
            }
            .offset(x: 0, y: 25)
            
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear(perform: {
            self.fetchFirstStations()
        })
        
        // MARK: Detail
        .sheet(isPresented: $isPresentingDetail) {
            if let stationToPresent = self.viewModel.state.stationToPresent {
                CharginStationDetailView(viewModel: AnyViewModel(ChargingStationDetailViewModel(station: stationToPresent)))
            }
        }
        
        // MARK: Creation
        .sheet(isPresented: $isPresentingCreation) {
            CreateChargingStationView(ownerID: self.viewModel.ownerID) { newStation in
                // Create Station
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
    
    func fetchFirstStations() {
        print("Call Fetch first trigger!")
        self.viewModel.trigger(.fetchStations)
    }
    
    func fetchStationsLazily(currentStation: ChargingStation) {
        self.viewModel.trigger(.fetchStationsLazily(currentStation: currentStation))
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
        HomeView(viewModel: AnyViewModel(HomeViewModel(stationsService: FirestoreChargingStationsService(currentUserID: "nil"))))
    }
}
