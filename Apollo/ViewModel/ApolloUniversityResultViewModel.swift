//
//  ApolloUniversityResultViewModel.swift
//  Apollo
//
//  Created by Matoi on 17.07.2024.
//

import Combine
import Foundation


final class ApolloUniversityResultViewModel {
    
    // Properties
    private let service: ApolloAPIServiceStandart
    
    // Publishers
    var faculties: PassthroughSubject<[Faculty], Error> = PassthroughSubject<[Faculty], Error>()
    
    init(service: ApolloAPIServiceStandart) {
        self.service = service
    }
    
    func getFacultiesFor(university id: String) async -> Void {
        do {
            let fetchedFaculties: [String: Faculty] = try await service.fetch([String: Faculty].self, usingURL: "\(service.temporaryHostingURL)/faculties")

            let filteredFaculties: [Faculty] = fetchedFaculties.filter { faculty in
                guard let prefix = faculty.key.split(separator: "_").first else { return false }
                return prefix.lowercased() == id.lowercased()
            }.map({ $0.value })
        
            faculties.send(filteredFaculties)
            faculties.send(completion: .finished)
        } catch {
            faculties.send(completion: .failure(error))
        }
    }
}

