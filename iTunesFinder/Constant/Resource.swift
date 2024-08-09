//
//  Resource.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/9/24.
//

import UIKit

enum Resource {
    enum Font {
        static let regular13 = UIFont.systemFont(ofSize: 13)
        static let regular14 = UIFont.systemFont(ofSize: 14)
        static let regular15 = UIFont.systemFont(ofSize: 15)
        static let bold13 = UIFont.systemFont(ofSize: 13, weight: .bold)
        static let bold14 = UIFont.systemFont(ofSize: 14, weight: .bold)
        static let bold15 = UIFont.systemFont(ofSize: 15, weight: .bold)
        static let bold18 = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    enum Colors {
        static let lightGary = UIColor.lightGray
        static let systemGray = UIColor.systemGray6
        static let systemTint = UIColor.tintColor
    }
}
