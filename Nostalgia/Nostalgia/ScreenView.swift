//
//  ScreenView.swift
//  Nostalgia
//
//  Created by Vincenzo Ajello on 09/03/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit
import SpriteKit

class ScreenView: UIView
{
    var fuzzyAnimation:UIImageView!
    var contentView:UIView!
    var gameScene:GameSKcene!
    var skview:SKView!
    
    convenience init(width:CGFloat)
    {
        var statusBarFix:CGFloat = 15
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
        {
            //iPhone X
            //statusBarFix = statusBarFix
        }
        
        let h = (width*3/4) + statusBarFix
        self.init(frame: CGRect.init(x: 0, y: 0, width: width, height: h))
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red:0.12, green:0.12, blue:0.12, alpha:1.0)
        // self.layer.cornerRadius = 6

        let LRmargins:CGFloat = 10
        let screenW:CGFloat = self.frame.width - (LRmargins * 2)
        let screenH = (frame.size.height*3/4)
        let screenY = self.frame.size.height - screenH - LRmargins
        let screenR = CGRect.init(x: LRmargins, y: screenY, width: screenW, height: screenH)

        contentView = UIView.init(frame: screenR)
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.darkText
        self.addSubview(contentView)
        
        let fuzzyImage = UIImage.gifImageWithName("giphy")
        fuzzyAnimation = UIImageView.init(frame: screenR)
        fuzzyAnimation.image = fuzzyImage
        fuzzyAnimation.alpha = 0.1
        self.addSubview(fuzzyAnimation)
        
        let mask = UIImageView.init(frame: screenR)
        mask.image = UIImage.init(named: "ScreenMask")
        mask.image = mask.image?.withRenderingMode(.alwaysTemplate)
        mask.tintColor = UIColor(red:0.12, green:0.12, blue:0.12, alpha:1.0)
        self.addSubview(mask)
    }
    
    func startGame()
    {
        gameScene = GameSKcene(size: CGSize.init(width: contentView.frame.width - 30  , height: contentView.frame.height-30))
        gameScene.scaleMode = .aspectFill
        skview = setupSKView(size: gameScene.size)
        skview.presentScene(gameScene)
        contentView.addSubview(skview)
    }
    
    func stopGame()
    {
        skview.removeFromSuperview()
        gameScene = nil
        skview = nil
    }
    
    func setupSKView(size:CGSize) -> SKView
    {
        skview = SKView.init(frame: CGRect.init(x: 15, y: 15, width: size.width, height: size.height))
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

extension ScreenView
{
    func isiPhoneX()-> Bool
    {
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
        {
            //iPhone X
            return true
        }
        return false
    }
}

