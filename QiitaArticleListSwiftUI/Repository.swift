//
//  Repository.swift
//  QiitaArticleListSwiftUI
//
//  Created by AndoHikaru on 2022/02/21.
//

import Foundation
import SwiftUI

class Repository: ObservableObject {
    @Published var items: [Item] = []
    
    let requestUrl = URL(string: "https://qiita.com/api/v2/items?page=1&per_page=10&query=SwiftUI")!
    
    init() {
        load()
    }
    
    private func load() {
        var request = URLRequest(url: requestUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
        URLSession.shared.dataTask(with: request) { data, reponse, error in
            guard let data = data else {
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let reponseData = try? decoder.decode([Item].self, from: data) else {
                fatalError()
            }
            
            DispatchQueue.main.async {
                self.items = reponseData
            }
        }.resume()
    }
}
