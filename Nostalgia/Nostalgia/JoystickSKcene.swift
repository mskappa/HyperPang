//
//  JoystickSKcene.swift
//  Nostalgia
//
//  Created by Vincenzo Ajello on 05/03/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit
import SpriteKit

class JoystickSKcene: SKScene
{
    var stick : SKJoystick!
    var button : SKSpriteNode!
    let generator = UIImpactFeedbackGenerator(style: .heavy)

    override func didMove(to view: SKView)
    {
        self.backgroundColor = .clear
        
        let plateColor = UIColor(red:0.66, green:0.67, blue:0.69, alpha:1.0)
        let plate = SKSpriteNode(color: plateColor, size: view.frame.size)
        plate.position = CGPoint.init(x: view.frame.size.width/2, y: view.frame.size.height/2)
        self.addChild(plate)
        
        let screw1 = SKSpriteNode(color: .clear, size: CGSize.init(width: 30, height: 30))
        screw1.texture = SKTexture.init(image: UIImage.init(named: "Screw")!)
        screw1.position = CGPoint.init(x: 21, y: 21)
        self.addChild(screw1)
        
        let screw2 = SKSpriteNode(color: .clear, size: CGSize.init(width: 30, height: 30))
        screw2.texture = SKTexture.init(image: UIImage.init(named: "Screw")!)
        screw2.position = CGPoint.init(x: view.frame.size.width-21, y: 21)
        self.addChild(screw2)
        
        let screw3 = SKSpriteNode(color: .clear, size: CGSize.init(width: 30, height: 30))
        screw3.texture = SKTexture.init(image: UIImage.init(named: "Screw")!)
        screw3.position = CGPoint.init(x: 21, y: view.frame.size.height-21)
        self.addChild(screw3)
        
        let screw4 = SKSpriteNode(color: .clear, size: CGSize.init(width: 30, height: 30))
        screw4.texture = SKTexture.init(image: UIImage.init(named: "Screw")!)
        screw4.position = CGPoint.init(x: view.frame.size.width-21, y: view.frame.size.height-21)
        self.addChild(screw4)
        
        screw1.zRotation =  CGFloat(.pi/1.5)
        screw2.zRotation =  CGFloat(.pi/2.5)
        screw3.zRotation =  CGFloat(.pi/3.5)
        screw4.zRotation =  CGFloat(.pi/4.5)
        
        let joySize = CGSize(width:250,height:250)
        stick = SKJoystick.init(texture: nil, color: .clear, size: joySize, knob:"redKnob.png")
        stick.zPosition = 1
        stick.alpha = 1.0
        stick.position = CGPoint(x:(view.frame.size.width/2)-60,y:view.frame.size.height/2)
        stick.isUserInteractionEnabled = true
        self.addChild(stick)

        let buttonTexture = SKTexture(imageNamed:"btn-up-red")
        button = SKSpriteNode(texture:buttonTexture, size: CGSize.init(width: 90, height: 90))
        button.zPosition = 1
        button.alpha = 1.0
        button.name = "button"
        button.position = CGPoint(x:(view.frame.size.width/2)+80,y:(view.frame.size.height/2)-10)
        self.addChild(button)
        
        
    }
    
    
    func pressBtn(btn:SKSpriteNode, color:String)
    {
        if btn.action(forKey: "\(String(describing: btn.name))Pressed") != nil
        {
            btn.removeAllActions()
            btn.texture = SKTexture(imageNamed:"btn-up-\(color)")
        }
        else
        {
            let scaleDownAction = SKAction.scale(to: 0.99, duration: 0.25)
            let origTxt = btn.texture
            let changeTxt = SKTexture(imageNamed:"btn-down-\(color)")
            let changeTxtAction = SKAction.run
            {
                btn.texture = changeTxt
            }
            let origTxtAction = SKAction.run
            {
                btn.texture = origTxt
            }
            let playSound = SKAction.playSoundFileNamed("tap.mp3", waitForCompletion: true)
            let scaleUpAction = SKAction.scale(to: 1, duration: 0.25 / 2)
            btn.run(playSound)
            btn.run(SKAction.sequence([changeTxtAction,scaleDownAction,scaleUpAction,origTxtAction]),
            withKey: "\(String(describing: btn.name))Pressed")
            
            generator.impactOccurred()
            
            guard let _ = stick.delegate?.joystickButtonPressed(sender: btn) else { return }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            if touchedNode.name == "button"
            {
                pressBtn(btn: self.button,color: "red")
            }
        }
    }
}
