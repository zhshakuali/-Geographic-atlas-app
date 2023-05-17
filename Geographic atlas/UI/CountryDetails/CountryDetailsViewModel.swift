//
//  CountryDetailsViewModel.swift
//  Geographic atlas
//
//  Created by Жансая Шакуали on 15.05.2023.
//

import Foundation

protocol CountryDetailsViewModelProtocol: AnyObject {
    var countryFetched: ((CountryDetailsViewModel.ResultType) -> Void )? { get set }
    
    func fetchDetails()
}

final class CountryDetailsViewModel: CountryDetailsViewModelProtocol {
    
    private let countryCode: String
    private let networkService: NetworkServiceProtocol
    
    var items: [ContinentItemModel] = []
    var countryFetched: ((ResultType) -> Void)?
    
    init(countryCode: String, networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.countryCode = countryCode
        self.networkService = networkService
    }
    
    func fetchDetails() {
        NetworkService.shared.getCountryDetails(code: countryCode) { [weak self] result in
            guard let self else {
                return
            }
            
            switch result {
            case let .success(country):
                guard let countryDetail = country.first else {
                    self.resolveFetchResult(.error(AppError.unknown.message))
                    return
                }
                
                self.resolveFetchResult(.success(.init(countryDetail: countryDetail)))
                
            case let .failure(error):
                self.resolveFetchResult(.error(error.message))
            }
        }
    }
    
    private func resolveFetchResult(_ result: ResultType) {
        DispatchQueue.main.async {
            self.countryFetched?(result)
        }
    }
}

extension CountryDetailsViewModel {
    enum ResultType {
        case success(CountryDetailItem)
        case error(String)
    }
}

class CountryDetailItem {
    let name: String
    let flag: String
    let region: String?
    let capital: [String]
    let capitalCoordinates: String?
    let population: String
    let area: String
    let currency: [String]
    let timezones: [String]
    
    init(countryDetail: CountryDetail) {
        self.name = countryDetail.name.common
        self.flag = countryDetail.flags.png
        self.region = countryDetail.subregion
        self.capital = countryDetail.capital ?? []
        self.capitalCoordinates = countryDetail.capitalInfo?.formattedCoordinates()
        
       
//        if (countryDetail.population != 0) && countryDetail.area > 1_000_000{
//            self.population = "\(countryDetail.population / 1_000_000) mln"
//            self.area = "\(countryDetail.area / 1_000_000) km²"
//        } else {
//            self.population = "\(countryDetail.population) mln"
//            self.area = "\(countryDetail.area) km²"
//        }
        
        
        if countryDetail.population > 1_000_000{
            self.population = "\(countryDetail.population / 1_000_000) mln"
        } else {
            self.population = "\(countryDetail.population) mln"
        }
        
        if countryDetail.area > 1_000_000{
            self.area = "\(countryDetail.area / 1_000_000) mln km²"
        } else {
            self.area = "\(countryDetail.area) km²"
        }
    
        self.currency = countryDetail.currencies?.formattedCurrencies() ?? []
        self.timezones = countryDetail.timezones ?? []
    }
}
