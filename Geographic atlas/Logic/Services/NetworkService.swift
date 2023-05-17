//
//  Service.swift
//  Geographic atlas
//
//  Created by Жансая Шакуали on 13.05.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func getList(completion: @escaping ((Result<[Country], AppError>) -> Void))
    func getCountryDetails(code: String, completion: @escaping ((Result<CountryDetailElement, AppError>) -> Void))
}

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private let client = NetworkClient()
    
    private init() { }
    
    func getList(completion: @escaping ((Result<[Country], AppError>) -> Void)) {
        let request = CountryListRequest()
        client.callRequest(request, completion: completion)
    }
    
    func getCountryDetails(code: String, completion: @escaping ((Result<CountryDetailElement, AppError>) -> Void)) {
        let request = CountryDetailRequest(countryCode: code)
        client.callRequest(request, completion: completion)
    }
    
    private struct CountryListRequest: NetworkRequest{
        var apiPath: String = APIEndPoint.Countries.countries
    }
    
    private struct CountryDetailRequest: NetworkRequest{
        var apiPath: String
        
        init(countryCode: String) {
            self.apiPath = APIEndPoint.Countries.countryDetails.replacingOccurrences(of: "{code}", with: countryCode)
        }
    }
}

fileprivate final class NetworkClient {
    private let session = URLSession.shared
    
    func callRequest<Model: Decodable>(
        _ request: NetworkRequest,
        completion: @escaping ((Result<Model, AppError>) -> Void)
    ) {
        guard let url = URL(string: request.webServiceURL + request.apiPath) else {
            return
        }
        session.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            guard let self else {
                return
            }
            
            if let error {
                completion(.failure(self.handleError(error)))
            }
            
            guard
                let urlResponse = response as? HTTPURLResponse,
                (200...299).contains(urlResponse.statusCode),
                let data
            else {
                completion(.failure(.failedRequest))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(Model.self, from: data)
                completion(.success(result))
            } catch {
                print(error)
            }
        }.resume()
    }
    
    private func handleError(_ error: Error) -> AppError {
        switch error {
        case let apiError as AppError:
            return apiError
        case URLError.notConnectedToInternet:
            return AppError.unreachable
        default:
            return AppError.failedRequest
        }
    }
}
