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
    
    
}
