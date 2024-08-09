//
//  DetailViewModel.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/9/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel {
    private let disposeBag = DisposeBag()
    
    let appData: BehaviorRelay<App?> = BehaviorRelay(value: nil)

    struct Input {
        
    }
    
    struct Output {
        let appData: BehaviorRelay<App?>
    }
    
    func transform() -> Output {
        let outputData: BehaviorRelay<App?> = BehaviorRelay(value: nil)
    
        appData
            .bind(to: outputData)
            .disposed(by: disposeBag)
        
        let output = Output(appData: outputData)
        return output 
    }
}
