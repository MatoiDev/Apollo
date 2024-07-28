//
//  ApolloUniversitiesScreenViewModel.swift
//  Apollo
//
//  Created by Matoi on 17.07.2024.
//

import Combine
import Foundation

final class ApolloUniversitiesScreenViewModel {
    // Properties
    private let service: ApolloAPIServiceStandart
    
    // Publishers
    @Published var errorLog: String? = nil
    @Published var universities: [University] = []
    @Published var searchText: String = "" {
        didSet {
            Task {
                do {
                    try await updateFetchedResults()
                } catch {
                    errorLog = error.localizedDescription
                }
            }
        }
        willSet {
            errorLog = nil
        }
    }
    
    init(service: ApolloAPIServiceStandart) {
        self.service = service
        
        Task { try await updateFetchedResults() }
    }

    func updateFetchedResults() async throws -> Void {
        do {
            let fetchedUniversities: [University] = try await fetchUniversities()
            universities = fetchedUniversities
            errorLog = nil
        } catch {
            errorLog = error.localizedDescription
            universities = []
        }
    }

    private func fetchUniversities() async throws -> [University] {
        do {
            let universities: [String: University] = try await service.fetch(Dictionary<String, University>.self, usingURL: "\(service.temporaryHostingURL)/universities")
            
            guard !searchText.isEmpty else { return universities.map( { $0.value } ) }
            
            return universities.values.filter { university in university.tag.lowercased().contains(searchText.lowercased())}
        } catch {
            universities = []
            throw error
        }
    }
}
