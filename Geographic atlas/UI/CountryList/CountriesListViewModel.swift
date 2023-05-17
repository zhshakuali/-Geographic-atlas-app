//
//  CountriesListViewModel.swift
//  Geographic atlas
//
//  Created by Жансая Шакуали on 12.05.2023.
//

import Foundation

protocol CountriesListViewModelProtocol: AnyObject {
    var numberOfSections: Int { get }
    var countriesFetched: ( (String?) -> Void)? { get set }
    
    func numberOfItems(in section: Int) -> Int
    func countryItem(for section: Int, at index: Int) -> CountryItemModel
    func titleOfContinent(for section: Int) -> String
    func fetchCountries()
}

final class CountriesListViewModel: CountriesListViewModelProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    var items: [ContinentItemModel] = []
    
    var numberOfSections: Int {
        items.count
    }
    
    var countriesFetched: ( (String?) -> Void)?
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func numberOfItems(in section: Int) -> Int {
        items[section].countries.count
    }
    
    func countryItem(for section: Int, at index: Int) -> CountryItemModel {
        items[section].countries[index]
    }
    
    func titleOfContinent(for section: Int) -> String {
        items[section].continent
    }

    func fetchCountries() {
        NetworkService.shared.getList { [weak self] result in
            guard let self else {
                return
            }
            
            var errorMessage: String?
            switch result {
            case let .success(countries):
                var continentDict = [String: [Country]]()

                for country in countries {
                    for continent in country.continents {
                        if let _ = continentDict[continent] {
                            continentDict[continent]!.append(country)
                        } else {
                            continentDict[continent] = [country]
                        }
                    }
                }

                self.items = continentDict.map {
                    ContinentItemModel(continent: $0.key, countries: $0.value.map { CountryItemModel(country: $0) })
                }
                
            case let .failure(failure):
                errorMessage = failure.message
            }
            
            DispatchQueue.main.async {
                self.countriesFetched?(errorMessage)
            }
        }
    }
}

class ContinentItemModel {
    let continent: String
    let countries: [CountryItemModel]
    
    init(continent: String, countries: [CountryItemModel]) {
        self.continent = continent
        self.countries = countries
    }
}

class CountryItemModel {
    let flagImageURL: String
    let country: String
    let capital: String
    let population: String
    let area: String
    let currencies: [String]
    let countryCode: String
    var isExpanded = false
    
    init(
        country: Country
    ) {
        self.flagImageURL = country.flags.png
        self.country = country.name.common
        self.capital = country.capital?.first ?? ""
       

        if country.population > 1000000 {
            self.population = String((country.population / 1_000_000)) + " mln"
        } else{
            self.population = String((country.population)) + " mln"
        }
        if country.area > 1000000 {
            self.area = String((country.area / 1_000_000)) + " mln km²"
        } else{
            self.area = String((country.area)) + " km²"
        }
        
        


        self.countryCode = country.cca2
        self.currencies = country.currencies?.formattedCurrencies() ?? []
    }
}
