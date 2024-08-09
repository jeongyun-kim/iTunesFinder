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
    private let appIconImageView = AppIconImageView()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Font.regular15
        return label
    }()
    
    private let genreNameLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Font.bold13
        label.textColor = Resource.Colors.lightGary
        return label
    }()
    
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Font.bold13
        label.textColor = Resource.Colors.lightGary
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Font.bold13
        label.textColor = Resource.Colors.lightGary
        return label
    }()
    
    private let downloadButton = DownloadButton()
    
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
        }
    }
    
    func configureCell(_ data: App) {
        guard let appImageUrl = URL(string: data.appIconImageURL) else { return }
        appIconImageView.kf.setImage(with: appImageUrl)
        appNameLabel.text = data.appName
        genreNameLabel.text = data.genre
    }
}
