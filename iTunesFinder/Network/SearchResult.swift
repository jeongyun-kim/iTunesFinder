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
    let artworkUrl512: String // 앱아이콘 512
    let screenshotUrls: [String]
    let currentVersionReleaseDate: String // 최근 업데이트 날짜
    let artistName: String // 앱 이름
    let primaryGenreName: String // 기본 카테고리
    let formattedPrice: String // 가격
    let trackName: String // 부제목
    let description: String // 앱 설명
    let averageUserRating: Double // 별점
    let userRatingCount: Int // 리뷰수
}
