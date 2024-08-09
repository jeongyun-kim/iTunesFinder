//
//  Border.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/9/24.
//

import UIKit
import SnapKit

final class Border: UIView {
    
    init() {
        super.init(frame: .zero)
        backgroundColor = Resource.Colors.systemGray
        snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
