//
//  LeaderboardCell.swift
//  Nostalgia
//
//  Created by Vincenzo Ajello on 05/03/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class LeaderboardCell: UITableViewCell
{
    var playerRank:UILabel!
    var playerName:UILabel!
    var playerScore:UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundColor = UIColor.clear
        
        let cellW = UIScreen.main.bounds.width-110
        
        playerRank = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: 40, height: 40))
        //playerRank.backgroundColor = UIColor.red
        playerRank.textColor = UIColor.white
        playerRank.font = UIFont.init(name: "Pixel-Art", size: 12)
        self.addSubview(playerRank)
        
        playerName = UILabel.init(frame: CGRect.init(x: 60, y: 4, width: 60, height: 35))
        playerName.font = UIFont.init(name: "Pixel-Art", size: 18)
        //playerName.backgroundColor = UIColor.brown
        playerName.textColor = UIColor.white
        playerName.text = "---"
        self.addSubview(playerName)
        
        playerScore = UILabel.init(frame: CGRect.init(x: 125, y: 4, width: cellW-115, height: 35))
        playerScore.font = UIFont.init(name: "Pixel-Art", size: 18)
        //playerScore.backgroundColor = UIColor.brown
        playerScore.adjustsFontSizeToFitWidth = true
        playerScore.textColor = UIColor.white
        playerScore.textAlignment = .right
        playerScore.text = "0"
        self.addSubview(playerScore)
    }
    
    func setRank(rank:Int)
    {
        let rankString = getRankString(rank: rank+1)
        let nRange = NSRange.init(location: 0, length: 1)
        let attributedString = NSMutableAttributedString(string: rankString, attributes: nil)
        attributedString.setAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 24)], range: nRange)
        playerRank.attributedText = attributedString
    }
    
    func getRankString(rank:Int) -> String
    {
        switch rank
        {
            case 1:
                return "\(rank)st"
            case 2:
                return "\(rank)nd"
            case 3:
                return "\(rank)rd"
            default:
                return "\(rank)th"
        }
    }
    
    override func awakeFromNib()
    {super.awakeFromNib()}
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}
