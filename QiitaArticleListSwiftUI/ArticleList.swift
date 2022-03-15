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
            ZStack {
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
                Group {
                    if (viewModel.isLoading) {
                        ProgressView("Loading...")
                            .padding(.all, 16)
                            .progressViewStyle(.circular)
                    }
                }
            }
        }
    }
}

class ArticleListViewModel: ObservableObject {
    @ObservedObject var articleModel = ArticleModel()
    @Published var items = [Item]()
    @Published var isLoading = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        bind()
    }
    
    private func bind() {
        articleModel.$items.sink { [unowned self] items in
            self.items = items
        }
        .store(in: &cancellables)
        
        articleModel.$isLoading.sink { [unowned self] isLoading in
            self.isLoading = isLoading
        }
        .store(in: &cancellables)
    }
    
    func fetch(_ word: String) {
        articleModel.fetch(word)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList()
    }
}
