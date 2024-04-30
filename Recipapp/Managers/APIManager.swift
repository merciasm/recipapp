//
//  APIManager.swift
//  Recipapp
//
//  Created by Mércia Maguerroski on 4/29/24.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    private init () {}

    func fetchData<T: Decodable>(from url: URL, responseModel: T.Type, completion: @escaping (Result<Decodable, Error>) -> Void) {
        AF.request(url).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(responseModel.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
