//
//  RouteError.swift
//  ChargeUp (iOS)
//
//  Created by Adrian Haubrich on 19.12.21.
//

import Foundation

enum RouteError: String, Error {
    case invalidState = "Invalid state."
    
    case unableToDecodeTitle = "Unable to decode title."
    case unableToDecodeState = "Unable to decode state."
}
