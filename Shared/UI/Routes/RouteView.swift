//
//  RoutesView.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 18.12.21.
//

import SwiftUI
import Helena
import Prometheus
import MapKit

struct RouteView: View {
    
    // View Model
    @ObservedObject var viewModel: AnyViewModel<RouteState, RouteInput>
    
    // View
    let circleRadius: CGFloat = 20
    let strokeWidth: CGFloat = 4
    let spacing: CGFloat = 0
    let dash: CGFloat = 2
    
    // MARK: Body
    var body: some View {
        
        // Elements
        VStack(alignment: .leading) {
            
            // Elements
            ForEach(self.viewModel.route.elements, id: \.id) { element in
                if let elementStation = element.station {
                    RouteElementView(state: element.state, station: elementStation) { station in
                        // On selection
                        withAnimation {
                            self.selectCurrentStation(station)
                        }
                    }
                }
            }
            
        }
        .background {
            // Line
            HStack {
                Spacer().frame(width: circleRadius)
                VerticalLine()
                    .stroke(style: StrokeStyle(lineWidth: strokeWidth / 2, dash: [dash]))
                    .foregroundColor(Color.helenaTextSmallAccent)
                    .frame(width: strokeWidth / 2)
                    .frame(maxHeight: .infinity)
                Spacer()
            }
        }.padding()
        
    }
}


// MARK: - Trigger
extension RouteView {
    
    func selectCurrentStation(_ station: ChargingStation) {
        self.viewModel.trigger(.selectCurrentStation(station))
    }
    
}

struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RouteView(viewModel: AnyViewModel(RouteViewModel(route: Route(ownerID: "ownerID"))))
    }
}



// MARK: - Elements
struct RouteElementView: View {
    
    let state: RouteElementState
    let station: ChargingStation
    let onSelection: (_ station: ChargingStation) -> ()
    
    // View
    var circleRadius: CGFloat = 20
    var strokeWidth: CGFloat = 4
    
    var body: some View {
        HStack {
            RouteCircle(radius: circleRadius, strokeWidth: strokeWidth, state: state)
            ChargingStationCard(station: station, isCollapsable: true, initialIsCollabsed: isCollabsed()) {_ in
                // Select station
                self.onSelection(station)
                
            } onMapSelection: { station in
                // Open Maps
                self.openMaps(with: station)
            }
            .padding([.vertical, .trailing])
            .padding(.leading, 8)
            
        }
        .foregroundColor(getForegroundColor())
    }
    
    private func getForegroundColor() -> Color {
        switch state {
        case .done:
            return Color.helenaTextSmallAccent
        case .current:
            return Color.helenaText
        case .pending:
            return Color.helenaTextSmallAccent
        }
    }
    
    private func isCollabsed() -> Bool {
        /*switch state {
        case .done:
            return true
        case .current:
            return false
        case .pending:
            return true
        }*/
        return true
    }
    
    private func openMaps(with station: ChargingStation) {
        // Open with url (without annotation)
        /*let query = "?ll=\(station.annotation.coordinate.latitude),\(station.annotation.coordinate.longitude)"
        let path = "http://maps.apple.com/" + query
        
        // Open
        if let url = NSURL(string: path) {
            UIApplication.shared.open(url as URL)
        }*/
        
        // Open as MapItem
        let coordinate = CLLocationCoordinate2DMake(station.annotation.coordinate.latitude, station.annotation.coordinate.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.name = station.annotation.title
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
}


struct VerticalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}

struct RouteCircle: View {
    
    let radius: CGFloat
    let strokeWidth: CGFloat
    var state: RouteElementState = .pending
    
    var body: some View {
        Circle()
            .fill(Color.helenaBackground)
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(getStrokeColor(), lineWidth: strokeWidth)
                    
                    if state == .done {
                        Image(systemName: "checkmark")
                            .foregroundColor(getStrokeColor())
                            .helenaFont(type: .emphasizedText)
                    } else if state == .current {
                        Image(systemName: "circle.circle.fill")
                            .foregroundColor(getStrokeColor())
                            .helenaFont(type: .emphasizedText)
                    } else if state == .pending {
                       Image(systemName: "circle.dashed")
                           .foregroundColor(getStrokeColor())
                           .helenaFont(type: .emphasizedText)
                   }
                }
            )
            .frame(width: radius * 2, height: radius * 2)
    }
    
    private func getStrokeColor() -> Color {
        switch state {
        case .done:
            return Color.green
        case .current:
            return Color.helenaTextAccent
        case .pending:
            return Color.helenaTextSmallAccent
        }
    }
    
}
