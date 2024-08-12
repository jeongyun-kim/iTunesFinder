//
//  SearchViewController.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/8/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Toast

final class SearchViewController: BaseViewController {
    private let vm = SearchViewModel()
    private let disposeBag = DisposeBag()
    private let searchController = UISearchController()
    private let tableView = UITableView()
    
    override func setupHierarchy() {
        view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupUI() {
        setupTableView()
        configureNavigation()
        searchController.searchBar.placeholder = "앱을 검색해보세요"
    }
    
    private func configureNavigation() {
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
    }
    
    private func setupTableView() {
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    override func bind() {
        let searchKeyword = searchController.searchBar.rx.text.orEmpty
        let searchBtnTapped = searchController.searchBar.rx.searchButtonClicked.withLatestFrom(searchKeyword)
        let cancelBtnTapped = searchController.searchBar.rx.cancelButtonClicked
        let transitionDetailView = tableView.rx.modelSelected(App.self)
        
        let input = SearchViewModel.Input(searchBtnTapped: searchBtnTapped, 
                                          cancelBtnTapped: cancelBtnTapped, transitionDetailView: transitionDetailView)
        let output = vm.transform(input)
        
        output.searchResults
            .asDriver(onErrorJustReturn: []) // 에러나면 빈배열 리턴
            .drive(tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                cell.configureCell(element)
                
                Observable.just(element)
                    .map { $0.screenshotUrls }
                    .map { $0.compactMap { URL(string: $0) }}
                    .map { $0.prefix(3) }
                    .bind(to: cell.collectionView.rx.items(cellIdentifier: ScreenshotCollectionViewCell.identifier, cellType: ScreenshotCollectionViewCell.self)) { (row, element, cell) in
                        cell.configureCell(element)
                    }.disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        
        output.errorMessage
            .asSignal()
            .emit(with: self) { owner, value in
                owner.view.makeToast(value)
            }.disposed(by: disposeBag)
        
        output.transitionDetailView
            .asSignal() 
            .emit(with: self) { owner, app in
                let vc = DetailViewController()
                vc.vm.appData.accept(app)
                owner.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
    }
}
