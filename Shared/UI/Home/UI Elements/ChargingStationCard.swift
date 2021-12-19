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
    var isCollapsable = false
    @State var initialIsCollabsed: Bool
    
    let onSelection: (_ station: ChargingStation) -> ()
    let onMapSelection: (_ station: ChargingStation) -> ()
    
    
    var body: some View {
        HelenaCard {
            VStack(alignment: .leading) {
                // MARK: Top
                ChargingStationCardTop(station: station, isCollapsable: isCollapsable, isCollapsed: self.$initialIsCollabsed)
                    .padding([.top, .horizontal])
                    .onTapGesture {
                        self.onSelection(station)
                    }
                
                // MARK: Map
                if !initialIsCollabsed {
                    ChargingStationCardBottom(station: station)
                        .onTapGesture {
                            self.onMapSelection(station)
                        }
                } else {
                    Spacer().frame(height: 12)
                }
            }
        }
    }
    
}


struct ChargingStationCardBottom: View {
    
    let station: ChargingStation
    
    var body: some View {
        
        VStack {
            if let coordinates = station.annotation.coordinate {
                HelenaMapView(centerCoordinate: coordinates, annotations: [station.annotation], onAnnotationSelection: { _ in })
                    .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                    .cornerRadius(HelenaLayout.cornerRadius, corners: [.bottomLeft, .bottomRight])
                    .clipped()
            }
        }
        
    }
    
}


struct ChargingStationCardTop: View {
    
    let station: ChargingStation
    
    var isCollapsable = false
    @Binding var isCollapsed: Bool
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(station.annotation.title ?? "Unknown Station")
                    .helenaFont(type: .cardTitle)
                Text(station.annotation.subtitle ?? "")
                    .helenaFont(type: .cardSmall)
                    .foregroundColor(Color.helenaTextSmallAccentStrong)
            }
            Spacer()
            
            TagText(text: "0.38€")
            TagText(text: "22kw")
            
            if isCollapsable {
                Image(systemName: isCollapsed ? "chevron.forward.circle.fill" : "chevron.down.circle.fill")
                    .onTapGesture {
                        withAnimation {
                            self.isCollapsed.toggle()
                        }
                    }
            }
            
        }
        
    }
    
}
