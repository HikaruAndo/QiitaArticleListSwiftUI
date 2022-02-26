//
//  ArticleList.swift
//  QiitaArticleListSwiftUI
//
//  Created by AndoHikaru on 2022/02/23.
//

import SwiftUI

struct ArticleList: View {
    @ObservedObject var repository = Repository()
    
    private func imageData(_ urlString: String?) -> UIImage {
        guard let urlData = try? Data(contentsOf: URL(string: urlString!)!) else {
            fatalError()
        }
        return UIImage(data: urlData)!
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(repository.items, id: \.self) { item in
                    NavigationLink {
                        ArticleDetail(url: item.url)
                    } label: {
                        HStack() {
                            Image(uiImage: imageData(item.user.profileImageUrl))
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text(item.title)
                        }
                    }
                }
            }
        }
    }
}

struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList()
    }
}
