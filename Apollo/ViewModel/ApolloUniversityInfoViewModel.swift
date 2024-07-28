//
//  ApolloUniversityInfoViewModel.swift
//  Apollo
//
//  Created by Matoi on 24.07.2024.
//

import Foundation
import UIKit
import Combine

final class ApolloUniversityInfoViewModel {
    
    private let service: ApolloAPIServiceStandart
    
    // Publishers
    let universityImage: PassthroughSubject<UIImage, Error> = PassthroughSubject<UIImage, Error>()

    init(service: ApolloAPIServiceStandart) {
        self.service = service
    }
    
    func getImage(for university: University) async -> Void {
        do {
            let image: UIImage = try await service.fetchImage(usingURL: university.imageURL)
            
            universityImage.send(image)
            universityImage.send(completion: .finished)
        } catch {
            universityImage.send(completion: .failure(error))
        }
        
    }
}
