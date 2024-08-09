//
//  DownloadButton.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/9/24.
//

import UIKit

final class DownloadButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        var config = UIButton.Configuration.filled()
        var attributedTitle = AttributedString.init("받기")
        attributedTitle.font = Resource.Font.bold14
        config.attributedTitle = attributedTitle
        config.baseBackgroundColor = Resource.Colors.systemGray
        config.baseForegroundColor = Resource.Colors.systemTint
        config.cornerStyle = .capsule
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
