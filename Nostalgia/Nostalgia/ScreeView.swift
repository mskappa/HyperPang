//
//  ScreeView.swift
//  Nostalgia
//
//  Created by Vincenzo Ajello on 09/03/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit
import SpriteKit

class ScreeView: UIView
{
    var fuzzyAnimation:UIImageView!
    var contentView:UIView!
    var gameScene:GameSKcene!
    var skview:SKView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red:0.12, green:0.12, blue:0.12, alpha:1.0)
        self.layer.cornerRadius = 6
        
        let statusBarFix:CGFloat = 15
        let f = CGRect.init(x: 0, y: statusBarFix, width: frame.size.width, height: frame.size.height)
        
        contentView = UIView.init(frame: CGRect.init(x: 2, y: 2+statusBarFix, width: frame.width-4, height: frame.height-4))
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.darkText
        self.addSubview(contentView)
        
        let fuzzyImage = UIImage.gifImageWithName("giphy")
        fuzzyAnimation = UIImageView.init(frame: f)
        fuzzyAnimation.image = fuzzyImage
        fuzzyAnimation.alpha = 0.1
        self.addSubview(fuzzyAnimation)
        
        let mask = UIImageView.init(frame: f)
        mask.image = UIImage.init(named: "ScreenMask")
        mask.image = mask.image?.withRenderingMode(.alwaysTemplate)
        mask.tintColor = UIColor(red:0.12, green:0.12, blue:0.12, alpha:1.0)
        self.addSubview(mask)
    }
    
    func startGame()
    {
        gameScene = GameSKcene(size: frame.size)
        gameScene.scaleMode = .aspectFill
        skview = setupSKView()
        skview.presentScene(gameScene)
        contentView.addSubview(skview)
    }
    
    func stopGame()
    {
        skview.removeFromSuperview()
        gameScene = nil
        skview = nil
    }
    
    func setupSKView() -> SKView
    {
        skview = SKView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        skview.ignoresSiblingOrder = true
        skview.showsFPS = true
        skview.showsNodeCount = true
        //skview.showsPhysics = true
        skview.showsDrawCount = true
        skview.allowsTransparency = true
        return skview
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}
