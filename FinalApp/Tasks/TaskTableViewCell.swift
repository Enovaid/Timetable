//
//  TaskTableViewCell.swift
//  FinalApp
//
//  Created by Alikhan Khassen on 18.12.2020.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var dueDateLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
