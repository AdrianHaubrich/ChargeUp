//
//  CreateChargingStationView.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 18.11.21.
//

import SwiftUI
import Helena
import Prometheus
import MapKit

struct CreateChargingStationView: View {
    
    let ownerID: String
    let onCreation: (_ newStaton: ChargingStation) -> ()
    
    @State var title = ""
    @State var subtitle = ""
    @State var location: Location?
    var spacing: CGFloat = 6
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                // Basic Data
                HelenaCard {
                    VStack {
                        HelenaTextField("Title", text: self.$title)
                        HelenaTextField("Subtitle", text: self.$subtitle)
                    }
                    .padding()
                }
                .padding(.horizontal)
                .padding(.vertical, spacing)
                
                // Location
                HelenaLocationCard(selectedLocation: location, onChange: { location in
                    DispatchQueue.main.async {
                        self.location = location
                    }
                })
                    .padding(.horizontal)
                    .padding(.vertical, spacing)
                
                // Create
                HelenaFullWidthButton(text: "Create") {
                    guard let coordinate = self.location?.coordinate else {
                        return
                    }
                    let station = ChargingStation(title: self.title, subtitle: self.subtitle, coordinate: coordinate, ownerID: ownerID, location: location)
                    self.onCreation(station)
                }
                .buttonStyle(HelenaPrimaryButtonStyle())
                .padding(.horizontal)
                .padding(.vertical, spacing)
                
            }
            .navigationTitle("Create Station")
        }
    }
}

struct CreateChargingStationView_Previews: PreviewProvider {
    static var previews: some View {
        CreateChargingStationView(ownerID: "ownerID") { newStation in
            // ...
        }
    }
}
