//
// Created by Matoi on 02.08.2024.
//

import Foundation
import Combine


final class ApolloProgramsViewModel {

    // Properties
    private let service: ApolloAPIServiceStandart

    // Publishers
    var programs: PassthroughSubject<[Faculty], Error> = PassthroughSubject<[Faculty], Error>()

    init(service: ApolloAPIServiceStandart) {
        self.service = service
    }

    func getFacultiesFor(university: University) async -> Void {
        do {
            let fetchedFaculties: [String: Faculty] = try await service.fetch([String: Faculty].self, usingURL: "\(service.temporaryHostingURL)/faculties")

            let filteredFaculties: [Faculty] = fetchedFaculties.filter { faculty in
                        guard let prefix = faculty.key.split(separator: "_").first else { return false }
                        return prefix.lowercased() == university.id.lowercased()
                    }.map({ $0.value })

            programs.send(filteredFaculties)
            programs.send(completion: .finished)
        } catch {
            programs.send(completion: .failure(error))
        }
    }
}
