//
//  DataLoaderProtocol.swift
//  SpareRoom_Test
//
//  Created by sabaz shereef on 05/04/21.
//

import Foundation

protocol DataLoaderProtocol {
    
    func fetchingForUpcomingEvents(completion: @escaping(Result<[upComingEvents],Error>) -> Void)
    
}
