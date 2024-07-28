//
//  ApolloAPIService.swift
//  Apollo
//
//  Created by Matoi on 14.06.2024.
//

import Foundation
import UIKit


protocol ApolloAPIServiceStandart {
    func fetch<T: Decodable>(_ type: T.Type, usingURL url: String?) async throws -> T
    func fetchImage(usingURL url: String?) async throws -> UIImage
}

extension ApolloAPIServiceStandart {
    var temporaryHostingURL: String {
        "https://matoidev.pythonanywhere.com"
    }
}

actor ApolloAPIService: ApolloAPIServiceStandart {
    private var rawDataCache: Dictionary<URL, LoadingState> = [:]
    private let imageCache = NSCache<NSString, UIImage>()
    private let decoder: JSONDecoder = JSONDecoder()

    static let shared = ApolloAPIService()

    private init() {}

    func fetch<T>(_ type: T.Type, usingURL url: String?) async throws -> T where T: Decodable {
        do {
            let data: Data = try await fetchData(with: url)
            return try decoder.decode(T.self, from: data)
        } catch {
            throw error
        }
    }

    func fetchImage(usingURL url: String?) async throws -> UIImage {
        guard let url = url else { throw URLError(.badURL)  }
        let cacheKey = NSString(string: url)

        if let cachedImage = imageCache.object(forKey: cacheKey) { return cachedImage }

        do {
            let data: Data = try await fetchData(with: url)
            guard let image: UIImage = UIImage(data: data) else { throw URLError(.fileDoesNotExist) }
            imageCache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            throw error
        }
    }

    private func fetchData(with stringURL: String?) async throws -> Data {
        guard let stringURL, let url: URL = URL(string: stringURL) else { throw URLError(.badURL) }

        if let state: LoadingState = rawDataCache[url] {
            switch state {
            case .loading(let task):
                return try await task.value
            case .done(let data):
                return data
            }
        }


        let task: Task<Data, Error> = Task<Data, Error> {
            do {
                let (data, _): (Data, URLResponse) = try await URLSession.shared.data(from: url)
                return data
            } catch {
                throw error
            }
        }

        rawDataCache[url] = .loading(task) // data racing

        do {
            let data = try await task.value
            rawDataCache[url] = .done(data) // data racing
            return data
        } catch {
            rawDataCache[url] = nil
            throw error
        }
    }
}

extension ApolloAPIService {
    enum LoadingState {
        case loading(Task<Data, Error>)
        case done(Data)
    }
}