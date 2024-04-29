//
//  PostTableViewCell.swift
//  iOSTest
//
//  Created by MacBook Pro on 29/04/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - setUpUI
    func setUpPostUI(data: Post) {
        lblTitle.text = data.title
        lblBody.text = data.body
    }
    
    func setUpCommentsUI(data: Comment) {
        lblTitle.text = data.email
        lblBody.text = data.body
    }
}
