//
//  DetailViewController.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/9/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class DetailViewController: BaseViewController {
    let vm = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let appIconImageView = AppIconImageView()
    private let appNameLabel = UILabel()
    private let sellerNameLabel = UILabel()
    private let downloadButton = DownloadButton(bgColor: Resource.Colors.systemTint, textColor: Resource.Colors.white, font: Resource.Font.bold15)
    private let topBorder = Border()
    private let releaseLabel = UILabel()
    private let versionLabel = UILabel()
    private let releaseNotesLabel = UILabel()
    private let bottomBorder = Border()
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
            make.top.equalTo(contentView.safeAreaLayoutGuide)
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
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomBorder.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(60)
        }
    }
    
    override func setupUI() {
        navigationItem.largeTitleDisplayMode = .never
        appNameLabel.font = Resource.Font.bold18
        appNameLabel.numberOfLines = 0
        sellerNameLabel.font = Resource.Font.regular14
        sellerNameLabel.textColor = Resource.Colors.lightGary
        releaseLabel.text = "새로운 소식"
        releaseLabel.font = Resource.Font.bold18
        versionLabel.font = Resource.Font.regular14
        versionLabel.textColor = Resource.Colors.lightGary
        releaseNotesLabel.font = Resource.Font.regular15
        releaseNotesLabel.numberOfLines = 0
        descLabel.font = Resource.Font.regular14
        descLabel.numberOfLines = 0
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
    }
}
