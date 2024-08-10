//
//  AppIconImageView.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/9/24.
//

import UIKit

final class AppIconImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        clipsToBounds = true
        layer.cornerRadius = 16
        backgroundColor = .systemGray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
