//
//  Country.swift
//  Geographic atlas
//
//  Created by Жансая Шакуали on 13.05.2023.
//

import Foundation

struct Country: Codable {
    let flags: Flags
    let name: Name
    let capital: [String]?
    let population: Int
    let currencies: Currencies?
    let area: Double
    let cca2: String
    let continents: [String]
}

struct CountryModel: Codable {
    let name: String
    let continents: [String]
}


// MARK: - Currencies
struct Currencies: Codable {
    let currency: [String: CurrencyInfo]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        currency = try container.decode([String: CurrencyInfo].self)
    }
}

extension Currencies {
    func formattedCurrencies() -> [String]? {
        currency?.map({ key, value in
            var result = ""
            result += key
            
            if let symbol = value.symbol {
                result += " (\(symbol))"
            }
            
            if let name = value.name {
                result += " (\(name))"
            }
            
            return result
        })
    }
}

// MARK: - Eur
struct CurrencyInfo: Codable {
    let name, symbol: String?
}

// MARK: - Flags
struct Flags: Codable {
    let png: String
}

// MARK: - Name
struct Name: Codable {
    let common, official: String
    let nativeName: NativeName?
}

// MARK: - NativeName
struct NativeName: Codable {
    let spa: Translation?
}
struct Translation: Codable {
    let official, common: String
}
