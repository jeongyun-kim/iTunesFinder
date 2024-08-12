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
        let searchBtnTapped: Observable<ControlProperty<String>.Element>
        let cancelBtnTapped: ControlEvent<Void>
        let transitionDetailView: ControlEvent<App>
    }
    
    struct Output {
        let searchResults: PublishRelay<[App]>
        let transitionDetailView: ControlEvent<App>
        let errorMessage: PublishRelay<String>
    }
    
    func transform(_ input: Input) -> Output {
        let searchResults = PublishRelay<[App]>()
        let errorMessage = PublishRelay<String>()
        
        // 1. URLSession + Observable
//        input.searchBtnTapped
//            .throttle(.seconds(3), scheduler: MainScheduler.instance) // 3초에 한 번씩
//            .flatMap { NetworkService.shared.fetchSearchResults($0) } // Observable 벗겨서 가져오기
//            .map { $0.results } // SearchResults의 results만 가져오기
//            .bind(to: searchResults) // output 데이터로 보내기
//            .disposed(by: disposeBag)
        
        // 2. Alamofire + Observable + Error Handling
//        input.searchBtnTapped
//            .throttle(.seconds(3), scheduler: MainScheduler.instance) // 3초에 한 번씩
//            .flatMap { NetworkService.shared.fetchSearchResultsAFObservable($0)
//                    .catch { error in // 네트워크 통신 중 에러가 발생했을 때 처리 
//                        errorMessage.accept("검색결과를 받아오는데 실패했습니다")
//                        searchResults.accept([])
//                        return Observable<SearchResult>.never()
//                    }
//            }
//            .map { $0.results } // SearchResults의 results만 가져오기
//            .bind(to: searchResults) // output 데이터로 보내기
//            .disposed(by: disposeBag)
        
        // 3. Alamofire + Single + Error Handling
        input.searchBtnTapped
            .throttle(.seconds(3), scheduler: MainScheduler.instance) // 3초에 한 번씩
            .flatMap { NetworkService.shared.fetchSearchResultsAFSingle($0)
                    .catch { error in // 네트워크 통신 중 에러가 발생했을 때 처리
                        errorMessage.accept("검색결과를 받아오는데 실패했습니다")
                        searchResults.accept([])
                        return Single<SearchResult>.never()
                    }
            }
            .map { $0.results } // SearchResults의 results만 가져오기
            .bind(to: searchResults) // output 데이터로 보내기
            .disposed(by: disposeBag)
        
        // Cancel버튼 눌러서 검색 종료할 때 결과 비워주기
        input.cancelBtnTapped
            .map { [] }
            .bind(to: searchResults)
            .disposed(by: disposeBag)

        let output = Output(searchResults: searchResults, transitionDetailView: input.transitionDetailView, errorMessage: errorMessage)
        return output
    }
}
