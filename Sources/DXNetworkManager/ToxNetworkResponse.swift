//
//  ToxNetworkResponse.swift
//  SFA
//
//  Created by Dani Tox on 23/12/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

protocol ToxNetworkResponse {
    var code : Int { get set }
    var message : String { get set }
    var errorCode : String? { get set }
}


/// Semplice Response con oggetto generico (deve conformare a Decodable).
struct NetworkResponse<T: Decodable>: ToxNetworkResponse, Decodable {
    var code: Int
    var message: String
    var errorCode: String?
    var object: T
}
