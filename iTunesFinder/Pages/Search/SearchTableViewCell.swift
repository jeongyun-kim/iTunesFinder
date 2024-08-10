//
//  SearchTableViewCell.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/9/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift

final class SearchTableViewCell: BaseTableViewCell {
    var disposeBag = DisposeBag()
    private let appIconImageView = ContentsImageView()
    
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
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout())
        cv.register(ScreenshotCollectionViewCell.self, forCellWithReuseIdentifier: ScreenshotCollectionViewCell.identifier)
        return cv
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func setupHierarchy() {
        contentView.addSubview(appIconImageView)
        contentView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(appNameLabel)
        labelStackView.addArrangedSubview(genreNameLabel)
        contentView.addSubview(downloadButton)
        contentView.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        appIconImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(55)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(appIconImageView.snp.trailing).offset(8)
            make.centerY.equalTo(appIconImageView.snp.centerY)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(appIconImageView.snp.centerY)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(240)
        }
    }
    
    func configureCell(_ data: App) {
        guard let appImageUrl = URL(string: data.appIconImageURL) else { return }
        appIconImageView.kf.setImage(with: appImageUrl)
        appNameLabel.text = data.appName
        genreNameLabel.text = data.genre
    }
    
    private func layout() -> UICollectionViewLayout {
        let inset: CGFloat = 16
        let spacing: CGFloat = 8
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: inset, bottom: 0, trailing: inset)
        section.interGroupSpacing = spacing
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
