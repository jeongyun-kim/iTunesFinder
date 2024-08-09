//
//  DownloadButton.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/9/24.
//

import UIKit
import SnapKit

final class DownloadButton: UIButton {
    
    init(bgColor: UIColor = Resource.Colors.systemGray, textColor: UIColor = Resource.Colors.systemTint, font: UIFont = Resource.Font.bold14) {
        super.init(frame: .zero)
        var config = UIButton.Configuration.filled()
        var attributedTitle = AttributedString.init("받기")
        attributedTitle.font = font
        config.attributedTitle = attributedTitle
        config.baseBackgroundColor = bgColor
        config.baseForegroundColor = textColor
        config.cornerStyle = .capsule
        configuration = config
        isEnabled = true
        snp.makeConstraints { make in
            make.width.equalTo(70)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
