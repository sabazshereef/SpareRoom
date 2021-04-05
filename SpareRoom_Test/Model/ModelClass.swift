//
//  ModelClass.swift
//  SpareRoom_Test
//
//  Created by sabaz shereef on 02/04/21.
//

import Foundation

// MARK: - Upcoming Events

struct upComingEvents: Codable {
   let cost: String?
    let endTime: String?
    let imageURL: String?
    let location: String?
    let startTime: String?
    let venue: String?

    enum CodingKeys: String, CodingKey {
        
        case cost
        case endTime = "end_time"
      case imageURL = "image_url"
        case location
        case startTime = "start_time"
        case venue
    }
}



