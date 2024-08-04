//
// Created by Matoi on 02.08.2024.
//

import Foundation
import Combine


final class ApolloOlympiadsViewModel {

    // Properties
    private let service: ApolloAPIServiceStandart

    // Publishers
    var olympiads: PassthroughSubject<[Olympiad], Error> = PassthroughSubject<[Olympiad], Error>()

    init(service: ApolloAPIServiceStandart) {
        self.service = service
    }

    func getOlympiads(for facultyID: String) async -> Void {
        do {
            let olympiads: [Olympiad] = try await service.fetch(Dictionary<String, Olympiad>.self, usingURL: "\(service.temporaryHostingURL)/olympiads")
                    .filter { $0.value.facultyId == facultyID }
                    .map { $0.value }

            self.olympiads.send(olympiads)
            self.olympiads.send(completion: .finished)
        } catch {
            olympiads.send(completion: .failure(error))
        }
    }
    
    func filter(_ olympiads: [Olympiad], with condition: String) -> [Olympiad] {
        olympiads.filter { olympiad in
            for word in condition.lowercased().components(separatedBy: " ") {
                return olympiad.name.lowercased().contains(word) || olympiad.profile.lowercased().contains(word) || olympiad.subject.lowercased().contains(word)
            }
            return false
        }
    }
}
