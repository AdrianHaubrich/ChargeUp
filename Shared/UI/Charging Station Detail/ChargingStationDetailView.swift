//
//  ChargingStationDetailView.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 18.11.21.
//

import SwiftUI
import Helena
import Prometheus

struct CharginStationDetailView: View {
    
    // View Model
    @ObservedObject var viewModel: AnyViewModel<ChargingStationDetailState, ChargingStationDetailInput>
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                
                // MARK: Location
                HelenaLocationCard(selectedLocation: viewModel.station.location, isEditing: false, onChange: { _ in })
                    .padding()
                
                // MARK: Details
                HelenaCard {
                    VStack {
                        HStack {
                            Spacer()
                        }
                        Text(viewModel.station.annotation.title ?? "Unknown Station")
                    }.padding()
                }
                .padding()
            }
            .navigationTitle(viewModel.station.annotation.title ?? "Unknown Station")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}
