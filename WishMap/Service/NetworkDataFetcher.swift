//
//  NetworkDataFetcher.swift
//  WishMap
//
//  Created by  Юлия Григорьева on 05.07.2022.
//

import UIKit

class NetworkDataFetcher {

    var networkService = NetworkService()
//    var networkServiceRandom = NetworkServiceRandom()

    func fetchImages(searchTerm: String, completion: @escaping (SearchResults?) -> ()) {
        networkService.request(searchTerm: searchTerm) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription) ")
                completion(nil)
            }
            let decode = self.decodeJSON(type: SearchResults.self, from: data)
            completion(decode)
        }
    }

//    func fetchRandomImages(completion: @escaping (SearchResults?) -> ()) {
//        networkServiceRandom.request() { (data, error) in
//            if let error = error {
//                print("Error received requesting data: \(error.localizedDescription) ")
//                completion(nil)
//            }
//            let decode = self.decodeJSON(type: SearchResults.self, from: data)
//            completion(decode)
//        }
//    }

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
