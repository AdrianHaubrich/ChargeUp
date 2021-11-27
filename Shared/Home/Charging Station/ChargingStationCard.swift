//
//  ChargingStationCard.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 18.11.21.
//

import SwiftUI
import Helena

struct ChargingStationCard: View {
    
    let station: ChargingStation
    let onSelection: (_ station: ChargingStation) -> ()
    
    var body: some View {
        HelenaCard {
            VStack(alignment: .leading) {
                // MARK: Top
                HStack {
                    VStack(alignment: .leading) {
                        Text(station.annotation.title ?? "Unknown Station")
                            .helenaFont(type: .cardTitle)
                        Text(station.annotation.subtitle ?? "")
                            .helenaFont(type: .cardSmall)
                            .foregroundColor(Color.helenaTextSmallAccentStrong)
                    }
                    Spacer()
                    
                    TagText(text: "0.3€")
                    TagText(text: "22kw")
                    
                }.padding([.top, .horizontal])
                
                // MARK: Map
                if let coordinates = station.annotation.coordinate {
                    HelenaMapView(centerCoordinate: coordinates, annotations: [station.annotation], onAnnotationSelection: { _ in })
                        .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                        .cornerRadius(HelenaLayout.cornerRadius, corners: [.bottomLeft, .bottomRight])
                        .clipped()
                }
            }
        }.onTapGesture {
            self.onSelection(station)
        }
    }
    
}
