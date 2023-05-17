//
//  APIEndPoint.swift
//  Geographic atlas
//
//  Created by Жансая Шакуали on 13.05.2023.
//

import Foundation

enum APIEndPoint{
    static let countriesAPI = "https://restcountries.com/v3.1"
    
    enum Countries{
        static let countries = "/all"
        static let countryDetails = "/alpha/{code}"
    }
}
