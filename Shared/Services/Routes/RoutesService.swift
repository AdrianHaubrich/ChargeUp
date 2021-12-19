//
//  RoutesService.swift
//  ChargeUp
//
//  Created by Adrian Haubrich on 19.12.21.
//

import Foundation

protocol RoutesService {
    
    var type: RoutesServiceType { get }
    
    // MARK: User
    var currentUserID: String { get }
    
    // MARK: Fetch
    func fetchNextRoutes(by creatorID: String, limit: Int?) async -> [Route]?
    
    // MARK: Listen
    
    // MARK: Update
    @discardableResult
    func updateRoute(_ route: Route) async throws -> Route
    
    // MARK: Create
    @discardableResult
    func createRoute(_ route: Route) async throws -> Route
    
}
