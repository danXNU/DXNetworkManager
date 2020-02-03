//
//  NetworkAgent.swift
//  SFA
//
//  Created by Dani Tox on 23/12/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

open class NetworkAgent<Response: Decodable> {
    
    public init() {}
    
    public var rawResponseGetter: ((String) -> Void)? = nil
    
    /// Esegue una richiesta HTTP alla path che gli dai tramite il parametro 'toxRequest'. Poi ritorna l'oggetto ricevuto dal server tramite il responseCompletion. Il tipo dell'oggetto lo decidi tu quando crei un'istanza di NetworkAgent con un Generic Type. Il generic type deve essere Decodable.
    ///
    /// - Parameters:
    ///   - toxRequest: Richiesta da esguire. Deve conformare al protocollo ToxNetworkRequest
    ///   - responseCompletion: la closure che viene chiamata ritornando un Swift.Result type contenente o l'errore o il tipo response che decidi te quando crei l'istanza di NetworkAgent
    public func executeNetworkRequest<RequestType : ToxNetworkRequest> (with toxRequest: RequestType, responseCompletion: ((Result<Response, NetworkError>) -> Void)? = nil)  {
        
        var urlString = ""
        var requireRawResponse = false
        
        if let req = toxRequest as? DirectRequest {
            urlString = req.directURL
            requireRawResponse = req.requireRawResponse
            
            if requireRawResponse && rawResponseGetter == nil {
                fatalError("DXNetworkManager: it's requested a raw response but no rawResponseGatter is setted")
            }
        } else if let req = toxRequest as? BasicRequest {
            let hostname = req.hostname
            let pathComponent = toxRequest.requestType
            urlString = "\(hostname)/\(pathComponent).php"
            
            if let args = toxRequest.args {
                urlString = NetworkAgent.getFullPath(from: urlString, with: args)
            }
            
        } else {
            fatalError("Tipo di RequestType non supportato")
        }
    
        
        guard let url = URL(string: urlString) else {
            responseCompletion?(.failure(.userError("Errore generico di quest'app (Codice: -1). URL non valido: \(urlString)")))
            return
        }

        
        let request = URLRequest(url: url)

        let session = URLSession.shared.dataTask(with: request) { [weak self] (data, responseWeb, error) in
            if error != nil {
                responseCompletion?(.failure(.other(error!)))
                return
            }
            
            guard let data = data else {
                responseCompletion?(.failure(.userError("Il server ha risposto con un contenuto vuoto (Codice errore -2")))
                return
            }
            
            if requireRawResponse {
                guard let str = String(data: data, encoding: .utf8) else {
                    responseCompletion?(.failure(.logError("Errore decoding raw response")))
                    return
                }
                self?.rawResponseGetter?(str)
            } else {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    responseCompletion?(.success(response))
                } catch {
                    responseCompletion?(.failure(.other(error)))
                }
            }
            
        }
    
        session.resume()
        
    }
    
    
    public static func getFullPath(from url: String, with args: [String: String]) -> String {
        var urlString = url
        urlString.append("?")
        
        for (key, value) in args {
            if key.isEmpty || value.isEmpty { continue }
            urlString.append("\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "DXNetworkManager: ERROR ADDING PERCENT ENCODING")")
            urlString.append("&")
        }
        
        if urlString.hasSuffix("&") {
            urlString.removeLast()
        }
        if urlString.hasSuffix("?") {
            urlString.removeLast()
        }
        
        return urlString
    }
    
    
    
}
