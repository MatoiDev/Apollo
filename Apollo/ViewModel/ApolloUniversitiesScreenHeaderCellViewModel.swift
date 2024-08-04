//
// Created by Matoi on 19.07.2024.
//

import Foundation
import Combine


final class ApolloUniversitiesScreenHeaderCellViewModel {

    // Properties
    private let service: ApolloAPIServiceStandart

    // Publishers
    var data: PassthroughSubject<(universitiesCount: Int, programsCount: Int, olympiadsCount: Int), Error> = PassthroughSubject<(universitiesCount: Int, programsCount: Int, olympiadsCount: Int), Error>()

    init(service: ApolloAPIServiceStandart) {
        self.service = service
    }

    func fetchData() async -> Void {
        do {
            async let universitiesCount: Int = try await fetchUniversitiesCount()
            async let programsCount: Int = try await fetchProgramsCount()
            async let olympiadsCount: Int = try await fetchOlympiadsCount()

            await data.send((universitiesCount: try universitiesCount, programsCount: try programsCount, olympiadsCount: try olympiadsCount))
            data.send(completion: .finished)
        } catch {
            data.send(completion: .failure(error))
        }
    }

    private func fetchUniversitiesCount() async throws -> Int {
        do {
            let universities: [String: University] = try await service.fetch([String: University].self, usingURL: "\(service.temporaryHostingURL)/universities")
            return universities.count
        } catch { throw error }
    }

    private func fetchProgramsCount() async throws -> Int {
        do {
            let olympiads: [String: Olympiad] = try await service.fetch([String: Olympiad].self, usingURL: "\(service.temporaryHostingURL)/olympiads")
            return Set(olympiads.map({ $0.value.faculty })).count
        } catch { throw error }
    }

    private func fetchOlympiadsCount() async throws -> Int {
        do {
            let olympiads: [String: Olympiad] = try await service.fetch([String: Olympiad].self, usingURL: "\(service.temporaryHostingURL)/olympiads")
            return Set(olympiads.map({ $0.value.name })).count
        } catch { throw error }
    }
}
