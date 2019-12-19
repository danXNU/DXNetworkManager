//
//  URLs.swift
//  SFA
//
//  Created by Dani Tox on 23/12/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

public struct URLs {
    #if DEBUG
        static let mainUrl = "http://192.168.1.5/iGio-Server"
    #else
        static let mainUrl = "https://danitoxserver.ddns.net"
    #endif
}
