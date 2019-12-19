//
//  ToxNetworkRequest.swift
//  SFA
//
//  Created by Dani Tox on 23/12/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

protocol ToxNetworkRequest : Codable {
    var requestType : RequestType { get set }
    var args: [String: String]? { get set }
}
extension ToxNetworkRequest {
    var args: [String: String]? {
        return nil
    }
}

/// Liste dei tipi di richieste
///
/// - preghiere
/// - materiali
/// - diocesi
/// - cities
enum RequestType: String, Codable {
    case preghiere = "preghiere"
    case materiali = "materiali"
    case locations = "locations"
    case diocesi = "diocesi"
    case cities = "citta"
    case localizedSites = "resources"
}

/// Struttura di una richiesta. Contiene solo la requestType che è la path del server.
/// - Esempio: requestType = "example" --> suppstudenti.com:5000/example
struct BasicRequest: ToxNetworkRequest {
    var requestType: RequestType
    var args: [String : String]? = nil
    
    init(requestType: RequestType, args: [String:String]? = nil) {
        self.requestType = requestType
        self.args = args
    }
    
    enum CodingKeys: String, CodingKey {
        case requestType = "type"
    }
}
