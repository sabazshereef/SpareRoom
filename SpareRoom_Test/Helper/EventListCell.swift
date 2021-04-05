//
//  EventListCell.swift
//  SpareRoom_Test
//
//  Created by sabaz shereef on 02/04/21.
//

import UIKit

class EventListCell: UITableViewCell {

    @IBOutlet weak var skeltonCamera: UIImageView!
    @IBOutlet weak var eventCost: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventVenue: UILabel!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
   
        eventImage.layer.cornerRadius = 2
        eventImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
