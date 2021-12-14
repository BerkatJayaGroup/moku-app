//
//  JsonHelper.swift
//  Moku
//
//  Created by Dicky Buwono on 07/12/21.
//

import Foundation

class JsonHelper: ObservableObject {
    @Published var motors = [Motor]()
    init() {
        loadData()
    }
    func loadData() {
        let filePath = Bundle.main.path(forResource: "data_motor", ofType: "json")
        if let filePath = filePath {
            let url = URL(fileURLWithPath: filePath)
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                do {
                    if let data = data {
                        let json = try JSONDecoder().decode([Motor].self, from: data)
                        DispatchQueue.main.sync {
                            self.motors = json
                        }
                    } else {
                        print("Json No Data")
                    }
                } catch {
                    print("Json error: ", error)
                }
            }.resume()
        }
    }
}
