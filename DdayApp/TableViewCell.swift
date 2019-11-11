//
//  TableViewCell.swift
//  DdayApp
//
//  Created by hyunwoo jung on 10/11/2019.
//  Copyright © 2019 EMMA. All rights reserved.
//

import UIKit

class TableTableViewCell: UITableViewCell {
    @IBOutlet weak var TheStartDay: UILabel!
    @IBOutlet weak var TheTerms: UILabel!
    @IBOutlet weak var TheCycle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
