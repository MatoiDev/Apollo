//
//  University.swift
//  Apollo
//
//  Created by Matoi on 14.06.2024.
//

import Foundation


struct UniversityLocation: Decodable {
    var latitude: Double
    let longitude: Double
}


struct UniversityAddress: Decodable {
    let street: String
    let district: String
    let city: String
    let postCode: String
    let country: String
    let location: UniversityLocation
}


struct UniversityContactLinks: Decodable {
    let vk: String?
    let telegram: String?
    let ok: String?
    let youtube: String?
}


struct University: Decodable {
    let id: String
    let tag: String
    let name: String
    let imageURL: String
    let description: String
    let address: UniversityAddress
    let yearOfFoundation: Int
    let url: String
    let mainOlympiad: String
    let contactLinks: UniversityContactLinks
    let contactNumber: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case tag
        case name
        case imageURL = "image_url"
        case description
        case address
        case yearOfFoundation = "year_of_foundation"
        case url
        case mainOlympiad = "main_olympiad"
        case contactLinks = "contact_links"
        case contactNumber = "contact_number"
    }
}

