//
//  NetworkServiceRandom.swift
//  WishMap
//
//  Created by  Юлия Григорьева on 18.07.2022.
//

import UIKit

class NetworkServiceRandom {

func request(completion: @escaping (Data?, Error?) -> Void) {
    let parameters = self.prepareParameters()
    let url = self.url(params: parameters)
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = prepareHeader()
    request.httpMethod = "get"
    let task = createDataTask(from: request, completion: completion)
    task.resume()
}

    private func prepareHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID 9Ve6CJPoODdCDtN8iXBM6uePfH1EAB64R7i0aRVhkgc"
        return headers
    }

    private func prepareParameters() -> [String: String] {
        var parameters = [String: String]()
        parameters["count"] = String(20)
        return parameters
    }

    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/random"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }

    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) ->
    URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
            completion(data, error)
            }
        }
    }
}

extension NetworkServiceRandom {
        func fetchRandomImages(completion: @escaping ([UnsplashPhoto]?) -> ()) {
            self.request() { (data, error) in
                if let error = error {
                    print("Error received requesting data: \(error.localizedDescription) ")
                    completion(nil)
                }
                let decode = self.decodeJSON(type: [UnsplashPhoto].self, from: data)
                completion(decode)
            }
        }

        func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
            let decoder = JSONDecoder()
            guard let data = from else { return nil }

            do {
                let objects = try decoder.decode(type.self, from: data )
                return objects
            } catch let jsonError {
                print("Failed to decode JSON", jsonError)
                return nil

            }
        }
}
