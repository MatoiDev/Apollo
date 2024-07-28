//
//  ApolloProgramCellViewModel.swift
//  Apollo
//
//  Created by Matoi on 07.07.2024.
//

import Foundation
import Combine

final class ApolloProgramViewModel {
    
    private let service: ApolloAPIServiceStandart
    
    // Publishers
    var olympiads: PassthroughSubject<[Olympiad], Error> = PassthroughSubject<[Olympiad], Error>()
    
    init(service: ApolloAPIServiceStandart) {
        self.service = service
    }
    
    func getOlympiads(_ ids: [String]) async -> Void {
        do {
            let olympiads: [String: Olympiad] = try await service.fetch([String: Olympiad].self, usingURL: "\(service.temporaryHostingURL)/olympiads")
            self.olympiads.send(ids.compactMap({ olympiads[$0] }))
            self.olympiads.send(completion: .finished)
        } catch {
            olympiads.send(completion: .failure(error))
        }
    }
}
