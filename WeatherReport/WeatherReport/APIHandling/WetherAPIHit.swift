//
//  WetherAPIHit.swift
//  WetherConditionApp
//
//  
//

import Foundation
protocol WetherApi{
    func Succes(data:[String:Any])
    func Fail()
}
class WetherAPIHit{
 var delegate : WetherApi?
 static let shared = WetherAPIHit()
    
  func wetherApi(key:String,state:String) {
     var urlString: String?
     urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(key)&q=\(state)&days=7&aqi=no&alerts=no".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
      
        guard let url = URL(string:urlString!)else {
           print("empty")
            return
        }
        // create the session object
        let session = URLSession.shared
        
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { [self] data, response, error in
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                return
            }
            
        guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid Response received from the server")
                return
            }
            
            // ensure there is data returned
            guard let responseData = data else {
                print("nil Data received from the server")
                return
            }
            
            do {
                
                if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                 delegate?.Succes(data: jsonResponse)
                  } else {
                    print("data maybe corrupted or in wrong format")
                    throw URLError(.badServerResponse)
                }
                
            } catch let error {
                delegate?.Fail()
                print(error.localizedDescription)
            }
            
        }
       
        
        task.resume()
        
        
    }
    
    
    
    
    
}
