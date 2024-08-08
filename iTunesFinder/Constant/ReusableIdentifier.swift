//
//  ReusableIdentifier.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/8/24.
//

import UIKit

protocol ReusableIdentifier {
    static var identifier: String { get }
}

extension UIView: ReusableIdentifier {
    static var identifier: String {
        return (String(describing: self))
    }
}
