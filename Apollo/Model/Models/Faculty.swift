//
//  Faculty.swift
//  Apollo
//
//  Created by Matoi on 14.06.2024.
//

import Foundation


struct Faculty: Decodable {
    let id: String
    let universityId: String
    let name: String
    let olympiads: [String]
    let facultyURL: String
}
