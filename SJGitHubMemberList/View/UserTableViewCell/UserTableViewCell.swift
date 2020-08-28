//
//  UserTableViewCell.swift
//  SJGitHubMemberList
//
//  Created by Zero on 2020/8/26.
//  Copyright © 2020 Zero. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var userProfileCellModel: UserProfileModel?{
        didSet{
            if  let url = URL(string: userProfileCellModel?.avatar_url ?? "") {
                 let data = try! Data(contentsOf: url )
                avatorImageView.image = UIImage(data: data)
            }
            nameLabel.text = userProfileCellModel?.login
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       self.avatorImageView.layer.cornerRadius = self.avatorImageView.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
