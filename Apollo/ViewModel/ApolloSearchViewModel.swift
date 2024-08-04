//
//  SearchViewModel.swift
//  Apollo
//
//  Created by Matoi on 17.06.2024.
//

import Foundation
import Combine


final class ApolloSearchViewModel {
    
    // Properties
    private var service: ApolloAPIServiceStandart
    
    // Publishers
    @Published var errorLog: String? = nil
    @Published var fetched: (olympiads: [GroupedOlympiad], universities: [University]) = ([], [])
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
    
    init(withService service: ApolloAPIServiceStandart) {
        self.service = service
    }
}

@MainActor
extension ApolloSearchViewModel {
    
    func updateFetchedResults() async throws -> Void {
        do {
            async let olympiads: [GroupedOlympiad] = try fetchOlympiads()
            async let universities: [University] = try fetchUniversities()

            fetched.olympiads = try await olympiads
            fetched.universities = try await universities

            errorLog = nil
        } catch {
            errorLog = error.localizedDescription
        }
    }
    
    private func fetchOlympiads() async throws -> [GroupedOlympiad] {
        do {
            let olympiads = try await service.fetch(Dictionary<String, GroupedOlympiad>.self, usingURL:  "\(service.temporaryHostingURL)/olympiads/grouped")
            return olympiads.values.filter { olympiad in
                olympiad.name.lowercased().contains(searchText.lowercased()) 
            }
        } catch {
            fetched.olympiads = []
            throw error
        }
    }
    
    private func fetchUniversities() async throws -> [University] {
        do {

            let universities: [String: University] = try await service.fetch(Dictionary<String, University>.self, usingURL: "\(service.temporaryHostingURL)/universities")
            return universities.values.filter { university in university.tag.lowercased().contains(searchText.lowercased())}
        } catch {
            fetched.universities = []
            throw error
       }
    }
    
    func clean() -> Void {
        fetched = ([], [])
        searchText = ""
        errorLog = nil
    }
}
