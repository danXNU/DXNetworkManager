//
//  ToxNetworkRequest.swift
//  SFA
//
//  Created by Dani Tox on 23/12/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

public protocol ToxNetworkRequest {
    var requestType : String { get set }
    var args: [String: String]? { get set }
}
extension ToxNetworkRequest {
    var args: [String: String]? {
        return nil
    }
}

/// Struttura di una richiesta. Contiene solo la requestType che è la path del server.
/// - Esempio: requestType = "example" --> suppstudenti.com:5000/example
public struct BasicRequest: ToxNetworkRequest {
    public var requestType: String
    public var args: [String : String]? = nil
    
    public init(requestType: String, args: [String:String]? = nil) {
        self.requestType = requestType
        self.args = args
    }
    
    enum CodingKeys: String, CodingKey {
        case requestType = "type"
    }
}

public struct DirectRequest: ToxNetworkRequest {
    public var requestType: String = ""
    public var args: [String : String]? = nil
    
    public var directURL: String
    public var requireRawResponse: Bool
    
    public init(urlString: String, requireRawResponse: Bool = false) {
        self.directURL = urlString
        self.requireRawResponse = requireRawResponse
    }
}
