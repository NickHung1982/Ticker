//
//  MsgListTableViewCell.swift
//  rideTicker
//
//  Created by Nick on 8/24/18.
//  Copyright © 2018 NickOwn. All rights reserved.
//

import UIKit

protocol actionCellDelegate{
    func didRequestShow(_ cell:MsgListTableViewCell)
    func didRequestEdit(_ cell:MsgListTableViewCell)
}
class MsgListTableViewCell: UITableViewCell {
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var line1Label: UILabel!
    @IBOutlet weak var line2Label: UILabel!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    var delegate:actionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickShowButton(_ sender: Any) {
        if let delegateObj = self.delegate{
            delegateObj.didRequestShow(self)
        }
    }
    @IBAction func clickEditButton(_ sender: Any) {
        if let delegateObj = self.delegate{
            delegateObj.didRequestEdit(self)
        }
    }
    
}
