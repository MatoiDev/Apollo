//
//  ApolloAPIServiceTests.swift
//  ApolloTests
//
//  Created by Matoi on 14.06.2024.
//

import XCTest


@testable import Apollo

final class ApolloAPIServiceTests: XCTestCase {
    let staticURL: String = "https://matoidev.pythonanywhere.com"
    var service: ApolloAPIServiceStandart!
    
    override func setUp() {
        service = ApolloAPIService.shared
    }
    
    override func tearDown() {
        service = nil
    }
    
    
    @MainActor
    func test_service_fetch_function_withGroupedOlympiads() async throws -> Void {
        do {
            let olympiads = try await service.fetch([String: GroupedOlympiad].self, usingURL: "\(staticURL)/olympiads/grouped")
            dump(olympiads.first!)
            XCTAssert(!olympiads.isEmpty)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    @MainActor
    func test_service_fetch_function_withOlympiads() async throws -> Void {
        do {
            let olympiads = try await service.fetch([String: Olympiad].self, usingURL: "\(staticURL)/olympiads")
            XCTAssert(!olympiads.isEmpty)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    @MainActor
    func test_service_fetch_function_withFaculties() async throws -> Void {
        do {
            let faculties = try await service.fetch([String: Faculty].self, usingURL: "\(staticURL)/faculties")
            XCTAssert(!faculties.isEmpty)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    @MainActor
    func test_service_fetch_function_withUniversities() async throws -> Void {
        do {
            let universities = try await service.fetch([String: University].self, usingURL: "\(staticURL)/universities")
            dump(universities)
            XCTAssert(!universities.isEmpty)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
