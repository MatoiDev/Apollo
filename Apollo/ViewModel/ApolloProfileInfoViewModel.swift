//
//  ApolloProfileInfoViewModel.swift
//  Apollo
//
//  Created by Matoi on 06.07.2024.
//

import Foundation
import Combine


final class ApolloProfileInfoViewModel {
    
    // Properties
    private let service: ApolloAPIServiceStandart
    
    // Publishers
    var olympiadLevel: PassthroughSubject<String, Error> = PassthroughSubject<String, Error>()
    
    init(service: ApolloAPIServiceStandart) {
        self.service = service
    }
    
    func getLevelForOlympiad(_ id: String) async -> Void {
        do {
            let olympiads: [String: Olympiad] = try await service.fetch([String: Olympiad].self, usingURL: "\(service.temporaryHostingURL)/olympiads")
            olympiadLevel.send(olympiads[id]?.level ?? "?")
            olympiadLevel.send(completion: .finished)
        } catch {
            olympiadLevel.send(completion: .failure(error))
        }
    }
}
