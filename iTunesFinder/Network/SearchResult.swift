//
//  SearchResult.swift
//  iTunesFinder
//
//  Created by 김정윤 on 8/8/24.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [App]
}

struct App: Decodable {
    let appIconImageURL: String // 앱아이콘 100
    let screenshotUrls: [String]
    let currentReleaseDate: String // 최근 업데이트 날짜
    let sellerName: String // 앱 이름
    let genre: String // 기본 카테고리
    let price: String // 가격
    let appName: String // 부제목
    let description: String // 앱 설명
    let rating: Double // 별점
    let ratingCnt: Int // 리뷰수
    let version: String // 최신 버전
    let releaseNotes: String // 업데이트 내역 
    
    enum CodingKeys: String, CodingKey {
        case appIconImageURL = "artworkUrl100"
        case screenshotUrls
        case currentReleaseDate = "currentVersionReleaseDate"
        case sellerName = "sellerName"
        case genre = "primaryGenreName"
        case price = "formattedPrice"
        case appName = "trackName"
        case description
        case rating = "averageUserRating"
        case ratingCnt = "userRatingCount"
        case version
        case releaseNotes
    }
}
