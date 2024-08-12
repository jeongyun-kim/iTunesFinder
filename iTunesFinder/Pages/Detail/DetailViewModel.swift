//
//  DetailViewModel.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/9/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel { // 따로 Input에 들어갈 Interaction이 없으므로 BaseViewModel 채택X
    private let disposeBag = DisposeBag()
    
    let appData: BehaviorRelay<App?> = BehaviorRelay(value: nil)

    struct Input {
        
    }
    
    struct Output {
        let appData: BehaviorRelay<App?>
        let screenshotUrls: BehaviorRelay<[URL]>
    }
    
    func transform() -> Output {
        let outputData: BehaviorRelay<App?> = BehaviorRelay(value: nil)
        let screenshotUrls: BehaviorRelay<[URL]> = BehaviorRelay(value: [])
    
        appData
            .bind(to: outputData)
            .disposed(by: disposeBag)
        
        appData
            .compactMap { $0 }
            .map { $0.screenshotUrls }
            .map { $0.compactMap { URL(string: $0) }}
            .bind(to: screenshotUrls)
            .disposed(by: disposeBag)
     
        let output = Output(appData: outputData, screenshotUrls: screenshotUrls)
        return output
    }
}
