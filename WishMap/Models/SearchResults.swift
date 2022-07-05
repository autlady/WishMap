//
//  SearchResults.swift
//  WishMap
//
//  Created by  Юлия Григорьева on 05.07.2022.
//

import UIKit

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let width: Int
    let height: Int
    let urls: [URLKing.RawValue: String]

    enum URLKing: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
