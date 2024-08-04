//
//  String+Extensions.swift
//  Apollo
//
//  Created by Matoi on 25.06.2024.
//

import Foundation


extension String {
    static func profiles(_ count: Int) -> String {
        if 11...19 ~= count { return "\(count) профилей"}
        switch (count % 10) {
        case 1:
            return "\(count) профиль"
        case 2...4:
            return "\(count) профиля"
        default:
            return "\(count) профилей"
        }
    }
    
    static func universities(_ count: Int) -> String {
        if 11...19 ~= count { return "\(count) ВУЗов"}
        switch (count % 10) {
        case 1:
            return "\(count) ВУЗ"
        case 2...4:
            return "\(count) ВУЗа"
        default:
            return "\(count) ВУЗов"
        }
    }
    
    static func programs(_ count: Int) -> String {
        if 11...19 ~= count { return "\(count) программ"}
        switch (count % 10) {
        case 1:
            return "\(count) программа"
        case 2...4:
            return "\(count) программы"
        default:
            return "\(count) программ"
        }
    }

    static func olympiads(_ count: Int) -> String {
        if 11...19 ~= count { return "\(count) олимпиад"}
        switch (count % 10) {
        case 1:
            return "\(count) олимпиада"
        case 2...4:
            return "\(count) олимпиады"
        default:
            return "\(count) олимпиад"
        }
    }
    
    static func educationalPrograms(_ count: Int) -> String {
        if 11...19 ~= count { return "\(count) Образовательных программ"}
        switch (count % 10) {
        case 1:
            return "\(count) Образовательная программа"
        case 2...4:
            return "\(count) Образовательных программы"
        default:
            return "\(count) Образовательных программ"
        }
    }
    
    static func educationalInstitutions(_ count: Int) -> String {
        if 11...19 ~= count { return "\(count) Учебных заведений"}
        switch count {
        case 1:
            return "\(count) Учебное заведение"
        case 2...4:
            return "\(count) Учебных заведения"
        default:
            return "\(count) Учебных заведений"
        }
    }
}
