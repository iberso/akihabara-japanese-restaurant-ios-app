//
//  customTableViewCell.swift
//  UTS_c14190189
//
//  Created by Adakah? on 09/10/21.
//

import UIKit

class customTableViewCell: UITableViewCell {

    @IBOutlet weak var labelFood: UILabel!
    @IBOutlet weak var labelHarga: UILabel!
    @IBOutlet weak var qtyFood: UITextField!
    @IBOutlet weak var imageFood: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
