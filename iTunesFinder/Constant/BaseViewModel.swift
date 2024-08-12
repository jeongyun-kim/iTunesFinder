//
//  BaseViewModel.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/12/24.
//

import Foundation

protocol BaseViewModel {
    // associated type = 사용할 데이터에 대한 변수/상수명 Placeholder
    // - 모든 ViewModel에서 Input, Output 구조체가 사용되는만큼 이러한 이름의 데이터가 사용될거라고 미리 명시해두는 것
    associatedtype Input
    associatedtype Output
    // - ViewModel에서 사용될 Func 정의 
    func transform(_ input: Input) -> Output
}
