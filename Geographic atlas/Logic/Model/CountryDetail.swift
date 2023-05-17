//
//  CountryDetail.swift
//  Geographic atlas
//
//  Created by Жансая Шакуали on 15.05.2023.
//

import Foundation

// MARK: - WelcomeElement
struct CountryDetail: Decodable {
    let flags: Flags
    let subregion: String?
    let name: Name
    let capital: [String]?
    let capitalInfo: CapitalInfo?
    let population: Int
    let area: Int
    let currencies: Currencies?
    let timezones: [String]?
}

// MARK: - CapitalInfo
struct CapitalInfo: Decodable {
    let latlng: [Double]?
}

extension CapitalInfo {
    func formattedCoordinates() -> String? {
        guard let latlng else {
            return nil
        }
        
        return latlng.map { String($0) }.joined(separator: "′, ").replacingOccurrences(of: ".", with: "°")
    }
}

typealias CountryDetailElement = [CountryDetail]
