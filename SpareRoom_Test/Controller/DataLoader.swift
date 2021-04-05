//
//  DataLoader.swift
//  SpareRoom_Test
//
//  Created by sabaz shereef on 02/04/21.
//

import Foundation
import UIKit


class eventApiLoader: DataLoaderProtocol {
//MARK:- Fetching Data from server
    func fetchingForUpcomingEvents(completion: @escaping(Result<[upComingEvents],Error>) -> Void) {
        
        guard let upcomingEventsUrl = URL(string: "https://api.jsonbin.io/b/6050a8a3683e7e079c519892") else { fatalError() }
        
        var upcomingResourceUrl = URLRequest(url:  upcomingEventsUrl)
    
        upcomingResourceUrl.setValue("$2b$10$76APFiNwr0YXKLX6FDCGiuks/TPFnSKkJleMY2uz1AR1EqTK9IODC", forHTTPHeaderField: "secret-key")
    
        
        let dataTask = URLSession.shared.dataTask(with: upcomingResourceUrl) { data,_,_ in
            
            guard let jsonData = data else{
                completion(.failure(Error.self as! Error))
                return
            }
            do{
                
                let decoder = JSONDecoder()
                
                let upcomingeventDetails = try decoder.decode([upComingEvents].self,from: jsonData)
                
                
                completion(.success(upcomingeventDetails))
            }
            catch{
                 completion(.failure(Error.self as! Error))
                
            }
        }
        dataTask.resume()
        
    }
}
//MARK:- Date and time formatters
extension Date {
    
    func dateConverter(date : Date, pass: Int) -> String {
       
        let dateFormatterNormal = DateFormatter()
        dateFormatterNormal.dateFormat = date.dateFormatWithSuffix(pass: pass)
        dateFormatterNormal.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterNormal.timeZone = TimeZone.current
        let endDate = dateFormatterNormal.string(from: date )
        return endDate
    }
        
    func dateFormatWithSuffix(pass: Int) -> String {
        
            if pass == 0{
            return "h:mm a"
                
            }else if pass == 1{
                return "h:mm"
            }
            else if pass == 3
            {
                return "MMMM"
            }
            else{
                return "'\(self.daySuffix())' MMMM"
            }
        }
    
        func daySuffix() -> String {
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components(.day, from: self)
            let dayOfMonth = components.day
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .ordinal
            return numberFormatter.string(from: dayOfMonth! as NSNumber)!
        }
    }
    



