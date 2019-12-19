//
//  File.swift
//  
//
//  Created by Dani Tox on 19/12/2019.
//

import Foundation

enum NetworkError : Error {
    case userError(String)
    case logError(String)
    case other(Error)
}
