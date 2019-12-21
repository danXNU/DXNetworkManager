//
//  ToxNetworkResponse.swift
//  SFA
//
//  Created by Dani Tox on 23/12/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

public protocol ToxNetworkResponse {
    var code : Int { get set }
    var message : String { get set }
    var errorCode : String? { get set }
}


/// Semplice Response con oggetto generico (deve conformare a Decodable).
public struct NetworkResponse<T: Decodable>: ToxNetworkResponse, Decodable {
    public var code: Int
    public var message: String
    public var errorCode: String?
    public var object: T
}


public struct BasicResponse: ToxNetworkResponse, Decodable {
    public var code : Int
    public var message : String
    public var errorCode : String?
}
