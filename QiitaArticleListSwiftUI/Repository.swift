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
    
    let requestUrlStr = "https://qiita.com/api/v2/items?page=1&per_page=2&query="
    
    func fetch(_ searchWord: String = "") {
        let url = URL(string: requestUrlStr + searchWord)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = ["Authorization": "Bearer cc09ad856b12e5c95193676f7da33597768ffe36"]
                
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
