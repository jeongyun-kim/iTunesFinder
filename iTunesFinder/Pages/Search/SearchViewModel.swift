//
//  SearchViewModel.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/9/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchBtnTapped: ControlEvent<Void>
        let keyword: ControlProperty<String>
        let cancelBtnTapped: ControlEvent<Void>
    }
    
    struct Output {
        let searchResults: PublishRelay<[App]>
    }
    
    func transform(_ input: Input) -> Output {
        let searchResults = PublishRelay<[App]>()

        input.searchBtnTapped
            .withLatestFrom(input.keyword) // 입력된 키워드 가져오기
            .throttle(.seconds(3), scheduler: MainScheduler.instance) // 3초에 한 번씩
            .flatMap { NetworkService.shared.fetchSearchResults($0) } // Observable 벗겨서 가져오기
            .map { $0.results } // SearchResults의 results만 가져오기
            .bind(to: searchResults) // output 데이터로 보내기
            .disposed(by: disposeBag)
        
        // Cancel버튼 눌러서 검색 종료할 때 결과 비워주기 
        input.cancelBtnTapped
            .map { [] }
            .bind(to: searchResults)
            .disposed(by: disposeBag)

        let output = Output(searchResults: searchResults)
        return output
    }
}
