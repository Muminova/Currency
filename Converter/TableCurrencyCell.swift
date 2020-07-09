//
//  TableCurrencyCell.swift
//  Converter
//
//  Created by ScrumTJ on 07.07.2020.
//  Copyright © 2020 ScrumTJ. All rights reserved.
//

import UIKit

class TableCurrencyCell: UITableViewCell {

    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var rate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
