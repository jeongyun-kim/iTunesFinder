//
//  DetailViewController.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/9/24.
//

import UIKit
import Kingfisher
import SnapKit
import RxSwift
import RxCocoa

final class DetailViewController: BaseViewController {
    let vm = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let appIconImageView = ContentsImageView()
    private let appNameLabel = UILabel()
    private let sellerNameLabel = UILabel()
    private let downloadButton = DownloadButton(bgColor: Resource.Colors.systemTint, textColor: Resource.Colors.white, font: Resource.Font.bold15)
    private let topBorder = Border()
    private let releaseLabel = UILabel()
    private let versionLabel = UILabel()
    private let releaseNotesLabel = UILabel()
    private let bottomBorder = Border()
    private let previewLabel = UILabel()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let descLabel = UILabel()
    
    
    override func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(appIconImageView)
        contentView.addSubview(appNameLabel)
        contentView.addSubview(sellerNameLabel)
        contentView.addSubview(downloadButton)
        contentView.addSubview(topBorder)
        contentView.addSubview(releaseLabel)
        contentView.addSubview(versionLabel)
        contentView.addSubview(releaseNotesLabel)
        contentView.addSubview(bottomBorder)
        contentView.addSubview(previewLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(descLabel)
    }
    
    override func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        
        appIconImageView.snp.makeConstraints { make in
            make.size.equalTo(90)
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(appIconImageView.snp.trailing).offset(12)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(appIconImageView.snp.top).offset(4)
        }
        
        sellerNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(appNameLabel.snp.leading)
            make.top.equalTo(appNameLabel.snp.bottom).offset(6)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.leading.equalTo(sellerNameLabel.snp.leading)
            make.top.equalTo(sellerNameLabel.snp.bottom).offset(8)
        }
        
        topBorder.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(downloadButton.snp.bottom).offset(20)
        }
        
        releaseLabel.snp.makeConstraints { make in
            make.leading.equalTo(appIconImageView)
            make.top.equalTo(topBorder.snp.bottom).offset(12)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.leading.equalTo(releaseLabel)
            make.top.equalTo(releaseLabel.snp.bottom).offset(8)
        }
        
        releaseNotesLabel.snp.makeConstraints { make in
            make.leading.equalTo(versionLabel)
            make.top.equalTo(versionLabel.snp.bottom).offset(16)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }

        bottomBorder.snp.makeConstraints { make in
            make.top.equalTo(releaseNotesLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
        
        previewLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomBorder.snp.bottom).offset(20)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(previewLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(480)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(60)
        }
    }
    
    override func setupUI() {
        navigationItem.largeTitleDisplayMode = .never
        appNameLabel.font = Resource.Font.bold22
        appNameLabel.numberOfLines = 0
        sellerNameLabel.font = Resource.Font.regular14
        sellerNameLabel.textColor = Resource.Colors.lightGary
        releaseLabel.text = "새로운 소식"
        releaseLabel.font = Resource.Font.bold20
        versionLabel.font = Resource.Font.regular14
        versionLabel.textColor = Resource.Colors.lightGary
        releaseNotesLabel.font = Resource.Font.regular15
        releaseNotesLabel.numberOfLines = 0
        descLabel.font = Resource.Font.regular14
        descLabel.numberOfLines = 0
        previewLabel.font = Resource.Font.bold20
        previewLabel.text = "미리보기"
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(ScreenshotCollectionViewCell.self, forCellWithReuseIdentifier: ScreenshotCollectionViewCell.identifier)
    }
    
    override func bind() {
        let output = vm.transform()
        
        output.appData
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .drive(with: self) { owner, data in
                guard let url = URL(string: data.appIconImageURL) else { return }
                owner.appIconImageView.kf.setImage(with: url)
                owner.appNameLabel.text = data.appName
                owner.sellerNameLabel.text = data.sellerName
                owner.versionLabel.text = "버전 \(data.version)"
                owner.releaseNotesLabel.text = data.releaseNotes
                owner.descLabel.text = data.description
            }.disposed(by: disposeBag)
        
        output.screenshotUrls
            .asDriver()
            .drive(collectionView.rx.items(cellIdentifier: ScreenshotCollectionViewCell.identifier, cellType: ScreenshotCollectionViewCell.self)) { (row, element, cell) in
                cell.configureCell(element)
            }.disposed(by: disposeBag)
    }
    
    private func layout() -> UICollectionViewLayout {
        let inset: CGFloat = 16
        let spacing: CGFloat = 12
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: inset, bottom: 0, trailing: inset)
        section.interGroupSpacing = spacing
        section.orthogonalScrollingBehavior = .groupPaging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
