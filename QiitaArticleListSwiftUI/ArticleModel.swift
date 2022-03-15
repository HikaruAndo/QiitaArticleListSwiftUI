//
//  ArticleModel.swift
//  QiitaArticleListSwiftUI
//
//  Created by AndoHikaru on 2022/02/21.
//

import Foundation
import Combine

class ArticleModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading = false
    
    private var cancellable: AnyCancellable?
    private let requestUrlStr = "https://qiita.com/api/v2/items?page=1&per_page=10&query="
                
    func fetch(_ searchWord: String = "") {
        let url = URL(string: requestUrlStr + searchWord)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        isLoading = true
        
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: [Item].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [unowned self] completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure(_):
                    self.isLoading = false
                }
            }, receiveValue: { [weak self] response in
                self?.items = response
            })
    }
    
    deinit {
        cancellable?.cancel()
    }
}
