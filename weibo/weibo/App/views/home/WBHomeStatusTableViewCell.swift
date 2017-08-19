//
//  WBHomeStatusTableViewCell.swift
//  weibo
//
//  Created by mason on 2017/8/19.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

//var profile_image_url : String? //用户头像
//var screen_name : String? //用户昵称
//var verified_type : Int = -1  //用户认证等级
//var mbrank : Int = 0 //会员等级

class WBHomeStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var mbrankImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headerImageView.layer.cornerRadius = 20.0
        headerImageView.layer.masksToBounds = true
    }

    var homeStatusViewModel : WBHomeStatusViewModel? {
        didSet {
            guard let homeStatusViewModel = homeStatusViewModel else {
                return
            }
            let url = homeStatusViewModel.status?.user?.profile_image_url ?? ""
            headerImageView.setImageWith(URL(string: url)!, placeholderImage: UIImage(named: "avatar_default_small"))
            
            nameLabel.text = homeStatusViewModel.status?.user?.screen_name
            verifiedImageView.image = homeStatusViewModel.verifiedImage
            mbrankImageView.image = homeStatusViewModel.vipImage
            timeLabel.text = homeStatusViewModel.createdAtText
            sourceLabel.text = homeStatusViewModel.sourceText
            contentLabel.text = homeStatusViewModel.status?.text
        }
    }

}















