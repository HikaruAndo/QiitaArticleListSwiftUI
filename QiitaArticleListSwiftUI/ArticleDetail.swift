//
//  ArticleDetail.swift
//  QiitaArticleListSwiftUI
//
//  Created by AndoHikaru on 2022/02/25.
//

import SwiftUI

struct ArticleDetail: View {
    let url: String
    
    var body: some View {
        ArticleWebView(url: url)
    }
}

struct ArticleDetail_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetail(url: "https://www.google.com/")
    }
}
