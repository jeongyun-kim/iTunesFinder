//
//  ScreenshotCollectionViewCell.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/10/24.
//

import UIKit
import Kingfisher
import SnapKit

final class ScreenshotCollectionViewCell: BaseCollectionViewCell {
    
    private let screenshotImageView = ContentsImageView()
    
    override func setupHierarchy() {
        contentView.addSubview(screenshotImageView)
    }
    
    override func setupConstraints() {
        screenshotImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
    }
    
    func configureCell(_ data: URL) {
        screenshotImageView.kf.setImage(with: data)
    }
}
