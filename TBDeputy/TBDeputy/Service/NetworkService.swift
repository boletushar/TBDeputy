//
//  NetworkService.swift
//  TBDeputy
//
//  Created by Tushar on 15/9/18.
//  Copyright © 2018 bole.tushar. All rights reserved.
//

import Foundation

class NetworkService {
    
    let baseAPI = "https://apjoqdqpi3.execute-api.us-west-2.amazonaws.com/dmc"
    
    // Function to post shift start/end details
    func postShiftUpdate(info: ShiftInfo, callback:@escaping (_ results : Bool, _ error : Error?) -> ()) {
        
        var url : URL?
        
        //Make JSON to send Shift start/end details to server
        var json = [String:Any]()
        
        if info.end != nil {
            
            url = URL(string: "\(baseAPI)/shift/end")
            json["time"] = info.end
            json["latitude"] = info.endLatitude
            json["longitude"] = info.endLongitude
            
        } else {
            
            url = URL(string: "\(baseAPI)/shift/start")
            json["time"] = info.start
            json["latitude"] = info.startLatitude
            json["longitude"] = info.startLongitude
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            
            // Request object to with Authorization header for POST method
            var request = self.getRequest(with: url!, for: "POST")
            request.httpBody = data
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    callback(true, error)
                    return
                }
                
                callback(false, error)
            }.resume()
            
        } catch let jsonError {
            print("JSON serialization error - ", jsonError)
            callback(false, nil)
        }
    }
    
    // Function to fetch all shifts user has done or currently doing
    func fetchAllShifts(callback:@escaping (_ results : Array<ShiftInfo>?, _ error : Error?) -> ()) {
        
        let url = URL(string: "\(baseAPI)/shifts")
        
        // Request object to with Authorization header for GET method
        let request = self.getRequest(with: url!, for: "GET")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                
                guard let dataResponse = data, error == nil else {
                    print(error?.localizedDescription ?? "Response error")
                    callback(nil, nil)
                    return
                }
                
                var results = try? JSONDecoder().decode([ShiftInfo].self, from: dataResponse)
                
                // Since in this case most recent shift will have the maximum id
                // so we can sort the results array based on value of id
                //
                // Ideally we should sort the array based on shift times and put the current shift
                // which has end attribute as nil or empty at the zeroth index of array
                
                results = results?.sorted(by: { (info1, info2) -> Bool in
                    if info1.id! > info2.id! {
                        return true
                    } else {
                        return false
                    }
                })
                callback(results, nil)
                
            } else {
                callback(nil, error)
            }
            
            }.resume()
    }
    
    // Create request object with Authorization header
    func getRequest(with url: URL, for method:String) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let authorizationKey = "Deputy  ".appending("eeac508ae21eb6b994e0b2aea9fa3175e794f142")
        request.addValue(authorizationKey, forHTTPHeaderField: "Authorization")
        return request
    }
}
