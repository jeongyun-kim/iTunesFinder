//
//  NetworkService.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/8/24.
//

import Foundation
import Alamofire
import RxSwift

private enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

final class NetworkService {
    static let shared = NetworkService()
    private init() { }
    
    // 1. URLSession / Observable
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
    
    // 2. Alamofire / Observable
    func fetchSearchResultsAFObservable(_ keyword: String) -> Observable<SearchResult> {
        return Observable<SearchResult>.create { observer -> Disposable in
            let url = "https://itunes.apple.com/search?term=\(keyword)&country=kr&entity=software"
            
            AF.request(url)
                .responseDecodable(of: SearchResult.self) { respose in
                    switch respose.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
        
            return Disposables.create()
        }
    }

    // 3. Alamofire / Single
    func fetchSearchResultsAFSingle(_ keyword: String) -> Single<SearchResult> {
        return Single<SearchResult>.create { single -> Disposable in
            let url = "https://itunes.apple.com/search?term=\(keyword)&country=kr&entity=software"
            
            AF.request(url)
                .responseDecodable(of: SearchResult.self) { respose in
                    switch respose.result {
                    case .success(let value):
                        single(.success(value))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
        
            return Disposables.create()
        }
    }
    
    // 4. Alamofire / Single / Result Type
    func fetchSearchResultsAFSingleRT(_ keyword: String) -> Single<Result<SearchResult, AFError>> {
        return Single.create { single -> Disposable in
            let url = "https://itunes.apple.com/search?term=\(keyword)&country=kr&entity=software"
            
            AF.request(url)
                .responseDecodable(of: SearchResult.self) { respose in
                    switch respose.result {
                    case .success(let value):
                        single(.success(.success(value))) // Single success 내부의 Result<SearchResult, AFError>의 success에 검색 결과 보내기
                    case .failure(let error):
                        single(.success(.failure(error))) // Single success 내부의 Result<SearchResult, AFError>의 failure에 에러 보내기
                        // -> Single 자체는 Error를 처리하지 않게 되면서 스트림이 끊기는 일이 일어나지 않음
                         // -> 대신 그 내부의 값을 Fail로 처리해주면서 에러 핸들링도 동시에 해줄 수 있음
                    }
                }
            
            return Disposables.create()
        }
    }
}
