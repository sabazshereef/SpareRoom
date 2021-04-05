//
//  MockDataLoader.swift
//  SpareRoom_TestTests
//
//  Created by sabaz shereef on 05/04/21.
//

import Foundation

@testable import SpareRoom_Test

class MockDataLoader: DataLoaderProtocol {
    func fetchingForUpcomingEvents(completion: @escaping (Result<[upComingEvents], Error>) -> Void) {
       
        
        guard let url = Bundle(for: MockDataLoader.self).url(forResource: "MockUpcomingEventApi", withExtension: "json") else {
            completion(.failure(Error.self as! Error))
            return
        }
        do{
           
            let data = try Data(contentsOf: url)
            
            let result = try JSONDecoder().decode([upComingEvents].self, from: data)
            print(result)
            completion(.success(result))
        }
        catch {
          
            
            completion(.failure(Error.self as! Error))
        }
        
    }
    
    
}
