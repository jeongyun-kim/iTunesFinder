//
//  NetworkService.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/8/24.
//

import Foundation
import RxSwift

private enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

final class NetworkService {
    static let shared = NetworkService()
    private init() { }
    
    func fetchSearchResults(_ keyword: String) -> Observable<SearchResult> {
        let result = Observable<SearchResult>.create { observer in
            let url = "https://itunes.apple.com/search?term=\(keyword)&country=kr&entity=software"
            guard let url = URL(string: url) else {
                observer.onError(NetworkError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                // 에러가 있다면 실패
                if let error {
                    observer.onError(NetworkError.invalidResponse)
                    return
                }
                
                // 응답이 HTTPURLResponse로 변환이 되고 상태코드가 200대라면 성공 / 아니면 실패
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    observer.onError(NetworkError.invalidResponse)
                    return
                }
                
                // 성공 -> 데이터가 있고 디코딩이 된다면 Next 이벤트로 방출하고 Complete
                // 실패 -> 에러 던지기
                if let data, let result = try? JSONDecoder().decode(SearchResult.self, from: data) {
                    observer.onNext(result)
                    observer.onCompleted()
                } else {
                    observer.onError(NetworkError.invalidData)
                    return
                }
            }.resume()
            return Disposables.create()
        }
        return result
    }
}
