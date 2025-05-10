//
//  NetworkService.swift
//  IosAssignment
//
//  Created by Kerlos on 10/05/2025.
//

import Foundation

class NetworkService{
    static let shared = NetworkService()
    
    func fetchData<T: Decodable>(APICase: API.Endpoint, DecodingModel: T.Type, completion: @escaping (Result<T, ErrorMessage>) -> Void) {
            
            let urlString = APICase.urlString
            
            guard let url = URL(string: urlString) else {
                completion(.failure(.invalidRequest))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    completion(.failure(.invalidRequest))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.invalidData))
                }
            }
            
            task.resume()
        }
}
