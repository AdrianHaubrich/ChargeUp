//
//  ChargingStationDetailView.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 18.11.21.
//

import SwiftUI
import Helena

struct CharginStationDetailView: View {
    
    let station: ChargingStation
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                // MARK: Location
                HelenaLocationCard(selectedLocation: station.location, isEditing: false, onChange: { _ in })
                
                // Details
                HelenaCard {
                    VStack {
                        HStack {
                            Spacer()
                        }
                        Text(station.annotation.title ?? "Unknown Station")
                    }.padding()
                }
                .padding()
            }
            .navigationTitle(station.annotation.title ?? "Unknown Station")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}
