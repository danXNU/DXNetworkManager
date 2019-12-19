//
//  NetworkAgent.swift
//  SFA
//
//  Created by Dani Tox on 23/12/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

class NetworkAgent<Response: Decodable> {
    
    /// Esegue una richiesta HTTP alla path che gli dai tramite il parametro 'toxRequest'. Poi ritorna l'oggetto ricevuto dal server tramite il responseCompletion. Il tipo dell'oggetto lo decidi tu quando crei un'istanza di NetworkAgent con un Generic Type. Il generic type deve essere Decodable.
    ///
    /// - Parameters:
    ///   - toxRequest: Richiesta da esguire. Deve conformare al protocollo ToxNetworkRequest
    ///   - responseCompletion: la closure che viene chiamata ritornando un Swift.Result type contenente o l'errore o il tipo response che decidi te quando crei l'istanza di NetworkAgent
    public func executeNetworkRequest<RequestType : ToxNetworkRequest> (with toxRequest: RequestType, responseCompletion: @escaping (Result<Response, NetworkError>) -> Void)  {
        
        let pathComponent = toxRequest.requestType.rawValue
        var urlString: String = "\(URLs.mainUrl)/\(pathComponent).php"
        
        if let args = toxRequest.args {
            urlString = NetworkAgent.getFullPath(from: urlString, with: args)
        }
        
        
        guard let url = URL(string: urlString) else {
            responseCompletion(.failure(.userError("Errore generico di quest'app (Codice: -1)")))
            return
        }

        
        let request = URLRequest(url: url)

        let session = URLSession.shared.dataTask(with: request) { (data, responseWeb, error) in
            if error != nil {
                responseCompletion(.failure(.other(error!)))
                return
            }
            
            guard let data = data else {
                responseCompletion(.failure(.userError("Il server ha risposto con un contenuto vuoto (Codice errore -2")))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                responseCompletion(.success(response))
            } catch {
                responseCompletion(.failure(.other(error)))
            }
        }
    
        session.resume()
        
    }
    
    
    static func getFullPath(from url: String, with args: [String: String]) -> String {
        var urlString = url
        urlString.append("?")
        
        for (key, value) in args {
            if key.isEmpty || value.isEmpty { continue }
            urlString.append("\(key)=\(value)")
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
