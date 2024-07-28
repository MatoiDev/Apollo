//
//  ApolloResources.swift
//  Apollo
//
//  Created by Matoi on 05.06.2024.
//

import UIKit


public enum ApolloResources {
    
    enum Strings {
        enum TabBar {
            static let mainPage: String = "Main"
            static let universitiesPage: String = "Universities"
            static let settings: String = "Settings"
        }
    }
    
    enum Images {
        enum TabBar {
            enum Selected {
                // Selected images
                static let mainPage: UIImage = UIImage(named: "house.fill")!
                static let universitiesPage: UIImage = UIImage(named: "building.2.fill")!
                static let settings: UIImage = UIImage(named: "gearshape.fill")!
            }

            // Plain images
            static let mainPage: UIImage = UIImage(named: "house")!
            static let universitiesPage: UIImage = UIImage(named: "building.2")!
            static let settings: UIImage = UIImage(named: "gearshape")!

        }

        enum Social {
            static let ok: UIImage = UIImage(named: "ok_logo")!
            static let vk: UIImage = UIImage(named: "vk_logo")!
            static let youtube: UIImage = UIImage(named: "youtube_logo")!
            static let telegram: UIImage = UIImage(named: "telegram_logo")!
        }
        
        enum Keyboard {
            static let collapse: UIImage = UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!
        }
        
        enum MainView {
            static let backgroundImage: UIImage = UIImage(named: "Apollo")!
            
            static let searchFieldLeadingImage: UIImage = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!
        }

        enum UniversityScreenHeaderCell {
            static let aphine: UIImage = UIImage(named: "Aphine")!
        }

        enum GeneralLeftCell {
            static let profile: UIImage = UIImage(named: "bookmark")!
            static let universities: UIImage = UIImage(named: "buildings")!
            static let level: UIImage = UIImage(named: "trophy")!
            static let programs: UIImage = UIImage(named: "graduation_cap")!
        }
        
        enum UniversityCell {
            static let chevronDown: UIImage = UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!
        }
        
        enum ApolloCondition {
            static let medalist: UIImage = UIImage(named: "medal")!
            static let winner: UIImage = UIImage(named: "trophy")!
        }

        enum TextFieldLeftIconPack {
            static let magnify: UIImage = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!
        }

        enum Button {
            static let backButtonImage: UIImage = UIImage(named: "chevron.backward.circle.fill")!.withRenderingMode(.alwaysTemplate)
        }

        enum ContactCell {
            static let phone: UIImage = UIImage(systemName: "phone")!
        }

        enum AddressCell {
            static let pin: UIImage = UIImage(systemName: "mappin.and.ellipse")!
        }
    }
   
}
