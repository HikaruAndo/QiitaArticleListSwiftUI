//
//  ArticleList.swift
//  QiitaArticleListSwiftUI
//
//  Created by AndoHikaru on 2022/02/23.
//

import SwiftUI
import Combine

struct ArticleList: View {
    @ObservedObject private var viewModel = ArticleListViewModel()
    @State private var searchWord = ""
    
    private func imageData(_ urlString: String?) -> UIImage {
        guard let urlData = try? Data(contentsOf: URL(string: urlString!)!) else {
            fatalError()
        }
        return UIImage(data: urlData)!
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("search", text: $searchWord, onCommit: {
                        viewModel.fetch(searchWord)
                    })
                }
                .padding()

                List {
                    ForEach(viewModel.items, id: \.self) { item in
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
                .listStyle(.grouped)
                .navigationTitle("Articles")
            }
        }
    }
}

class ArticleListViewModel: ObservableObject {
    @ObservedObject var articleModel = ArticleModel()
    @Published var items = [Item]()

    private var cancellable: AnyCancellable?

    init() {
        bind()
    }
    
    private func bind() {
        cancellable = articleModel.$items.sink { [unowned self] items in
            self.items = items
        }
    }
    
    func fetch(_ word: String) {
        articleModel.fetch(word)
    }
    
    deinit {
        cancellable?.cancel()
    }
}

struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList()
    }
}
