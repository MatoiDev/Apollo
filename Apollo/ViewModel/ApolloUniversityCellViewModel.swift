//
//  ApolloUniversityCellViewModel.swift
//  Apollo
//
//  Created by Matoi on 19.06.2024.
//

import Foundation
import UIKit
import Combine


final class ApolloUniversityCellViewModel {
    
    // Properties
    private let service: ApolloAPIServiceStandart
    
    // Publishers
    var university: PassthroughSubject<University, Error> = PassthroughSubject<University, Error>()
    var universityImage: PassthroughSubject<UIImage, Error> = PassthroughSubject<UIImage, Error>()
    var programs: PassthroughSubject<[Faculty], Error> = PassthroughSubject<[Faculty], Error>()
    
    init(service: ApolloAPIServiceStandart) {
        self.service = service
    }
    
    func getUniversityById(_ id: String) async -> Void {
        do {
            let universities: [String: University] = try await service.fetch([String: University].self, usingURL: "\(service.temporaryHostingURL)/universities")
            
            guard let fetchedUniversity = universities[id] else {
                university.send(completion: .failure(URLError(.fileDoesNotExist)))
                return
            }
            
            university.send(fetchedUniversity)
            university.send(completion: .finished)
            
            await fetchImageWithURL(fetchedUniversity.imageURL)
        } catch {
            university.send(completion: .failure(error))
        }
    }
    
    func fetchImageWithURL(_ url: String?) async -> Void {
        do {
            let image: UIImage = try await service.fetchImage(usingURL: url)
            universityImage.send(image)
            universityImage.send(completion: .finished)
        } catch {
            universityImage.send(completion: .failure(error))
        }
    }

    func fetchProgramsCountFor(university: University) async -> Void {
        do {
            let fetchedPrograms: [String: Faculty] = try await service.fetch([String: Faculty].self, usingURL: "\(service.temporaryHostingURL)/faculties")

            let filteredPrograms: [Faculty] = fetchedPrograms.filter { faculty in
                        guard let prefix = faculty.key.split(separator: "_").first else { return false }
                        return prefix.lowercased() == university.id.lowercased()
                    }.map({ $0.value })

            programs.send(filteredPrograms)
            programs.send(completion: .finished)
        } catch {
            programs.send(completion: .failure(error))
        }
    }

}
