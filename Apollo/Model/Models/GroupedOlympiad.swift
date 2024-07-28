//
//  GroupedOlympiad.swift
//  Apollo
//
//  Created by Matoi on 24.06.2024.
//

import Foundation

struct GroupedOlympiad: Decodable {
    let name: String
    let profiles: [String: [String: [String]]]
    let score: String
    let link: String
    let level: String
}

