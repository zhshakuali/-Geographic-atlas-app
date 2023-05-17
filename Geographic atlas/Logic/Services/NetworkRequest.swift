//
//  NetworkRequest.swift
//  Geographic atlas
//
//  Created by Жансая Шакуали on 13.05.2023.
//

import Foundation
protocol NetworkRequest {
    var webServiceURL: String { get }
    var apiPath: String { get set }
    
}
extension NetworkRequest {
    var webServiceURL: String{ APIEndPoint.countriesAPI }
}
