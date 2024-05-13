import Foundation

protocol NetworkServiceProtocol {
    func request(urlString: String, completion: @escaping (TableModel?, Error?) -> Void )
}

class Service: NetworkServiceProtocol {
    func request(urlString: String, completion: @escaping (TableModel?, Error?) -> Void ) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["X-API-KEY": "26928b90-643f-49f7-91d4-5587cf6a1f0e"]
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("error")
                    completion(nil, error)
                    return
                }
                if response != nil {
                    guard let data = data else { return }
                    do {
                        let films = try JSONDecoder().decode(TableModel.self, from: data)
                        completion(films, nil)
                    } catch let jsonError {
                        print(jsonError)
                        completion(nil, jsonError)
                    }
                }
            }
        }.resume()
    }
}
