//
//  Item.swift
//  QiitaArticleListSwiftUI
//
//  Created by AndoHikaru on 2022/02/21.
//

import Foundation

struct Item: Decodable, Hashable {
    let title: String
    let user: User
    let url: String
}

struct User: Decodable, Hashable {
    let profileImageUrl: String
}
