//
//  RestApi.swift
//  finerio-test
//
//  Created by Macintosh HD on 09/07/20.
//  Copyright © 2020 vicentesiis. All rights reserved.
//

import Foundation
import Alamofire

fileprivate let baseURL = "https://api.finerio.mx/api"


class RestAPI {
    
    class func camelCaseToSnakeCaseDecoder() -> JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }
    
    class func login(parameters: [String: Any], completion: @escaping (Result<Login, AFError>) -> Void) {
        
        let uri = baseURL + "/login"
        
        var request = URLRequest(url: URL(string: uri)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        AF.request(request)
            .responseDecodable(decoder: camelCaseToSnakeCaseDecoder(), completionHandler: { (response: DataResponse<Login, AFError>) in
                completion(response.result)
            })
        
    }
    
    class func currentUser(completion: @escaping (Result<CurrentUser, AFError>) -> Void) {
        
        let uri = baseURL + "/me"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "AccessToken")!,
            "Accept": "application/json"
        ]
        
        AF.request(uri.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!, method: .get, headers: headers)
            .responseDecodable { (response: DataResponse<CurrentUser, AFError>) in
                completion(response.result)
        }
        
    }
    
    class func movements(userID: String, parameters: [String: Any], completion: @escaping (Result<Movements, AFError>) -> Void) {
        
        let uri = baseURL + "/users/" + userID + "/movements"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "AccessToken")!,
            "Accept": "application/json"
        ]
        
        
        AF.request(uri.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!, method: .get, parameters: parameters, headers: headers)
            .responseDecodable { (response: DataResponse<Movements, AFError>) in
                completion(response.result)
        }
        
    }
    
}
