//
//  SearchTableViewCell.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/9/24.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchTableViewCell: BaseTableViewCell {
    private let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let genreNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        var attributedTitle = AttributedString.init("받기")
        attributedTitle.font = .systemFont(ofSize: 14, weight: .bold)
        config.attributedTitle = attributedTitle
        config.baseBackgroundColor = .systemGray6
        config.baseForegroundColor = .tintColor
        config.cornerStyle = .capsule
        button.configuration = config
        return button
    }()
    
    override func setupHierarchy() {
        contentView.addSubview(appIconImageView)
        contentView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(appNameLabel)
        labelStackView.addArrangedSubview(genreNameLabel)
        contentView.addSubview(downloadButton)
    }
    
    override func setupConstraints() {
        appIconImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(contentView.snp.centerY)
            make.size.equalTo(55)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(appIconImageView.snp.trailing).offset(8)
            make.centerY.equalTo(appIconImageView.snp.centerY)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(70)
        }
    }
    
    func configureCell(_ data: App) {
        guard let appImageUrl = URL(string: data.appIconImageURL) else { return }
        appIconImageView.kf.setImage(with: appImageUrl)
        appNameLabel.text = data.appName
        genreNameLabel.text = data.genre
    }
}
