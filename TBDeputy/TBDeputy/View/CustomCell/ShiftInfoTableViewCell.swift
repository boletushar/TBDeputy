//
//  ShiftInfoTableViewCell.swift
//  TBDeputy
//
//  Created by Tushar on 15/9/18.
//  Copyright © 2018 bole.tushar. All rights reserved.
//

import UIKit

class ShiftInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var shiftImageView: UIImageView!
    
    @IBOutlet weak var shiftStartTimeLabel: UILabel!
    @IBOutlet weak var shiftEndTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(data: ShiftInfo, index: Int) {
        
        //let startDate = Formatter.iso8601.date(from: data.start)
        
        self.shiftStartTimeLabel.text = "Start : \(data.getFormattedDate(dateStr: data.start))"
        self.shiftEndTimeLabel.text = data.getEndText()
        
        shiftImageView.tag = index
        
        if data.end == nil || data.end?.count == 0 {
            self.shiftImageView.image = #imageLiteral(resourceName: "logo")
        }
        
        if data.image != nil {
            
            if let url = URL(string: data.image!) {
                ImageService.downloadImage(withURL: url, andTag: index) { (image, tag) in
                
                    DispatchQueue.main.async {
                        if image != nil && self.shiftImageView.tag == tag {
                            self.shiftImageView.image = image
                        }
                    }
                }
            }
        }
    }
}
