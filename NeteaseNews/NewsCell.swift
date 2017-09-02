//
//  NewsCell.swift
//  NeteaseNews
//
//  Created by Neil Steven on 2017/8/20.
//  Copyright © 2017年 Neil Steven. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    var urlString = ""
    
    
    
    func configCellWith(data dict: Dictionary<String, Any>) {
        let title = dict["title"] as? String ?? "新闻标题获取失败"
        let source = dict["source"] as? String ?? "新闻来源获取失败"
        let replyCount = dict["replyCount"] as? Int ?? -9999
        let imgsrc = dict["imgsrc"] as? String ?? "新闻图片获取失败"
        let url = dict["url"] as? String ?? "新闻地址获取失败"
        
        titleLabel.text = title
        sourceLabel.text = source
        commentsLabel.text = formatReplyCount(number: replyCount)
        iconImageView.sd_setImage(with: URL(string: imgsrc))
        urlString = url
    }
    
    func formatReplyCount(number: Int?) -> String {
        if let number = number {
            if number > 9999 {
                return String(format: "%d.%d万跟帖", number / 10000, number % 1000 % 10)
            }
            else {
                return String(format: "%d跟帖", number)
            }
        }
        return "评论数获取失败"
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
