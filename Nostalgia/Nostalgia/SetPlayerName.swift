//
//  SetPlayerName.swift
//  Nostalgia
//
//  Created by Vincenzo Ajello on 06/03/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class SetPlayerName: UIView, SKJoystickDelegate
{
    let letters:[String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","U","R","S","T","U","V","W","X","Y","Z"]
    var labels:[UILabel] = []
    var currentLabelIndex = 0
    var latestInputTime = NSDate().timeIntervalSince1970
    var scoreLabel:UILabel!
    var score:Int!
    var delegate:GameEventDelegate!
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        let gameOverLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 160, height: 40))
        gameOverLabel.center = CGPoint.init(x: self.center.x, y: self.center.y - 80)
        gameOverLabel.font = UIFont.init(name: "Pixel-Art", size: 28)
        gameOverLabel.backgroundColor = UIColor.clear
        gameOverLabel.textAlignment = NSTextAlignment.center
        gameOverLabel.textColor = UIColor.white
        gameOverLabel.adjustsFontSizeToFitWidth = true
        gameOverLabel.text = "game over !"
        self.addSubview(gameOverLabel)
        
        let firstLetter = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        firstLetter.center = CGPoint.init(x: self.center.x-42, y: self.center.y-10)
        firstLetter.font = UIFont.init(name: "Pixel-Art", size: 38)
        firstLetter.backgroundColor = UIColor.clear
        firstLetter.textAlignment = NSTextAlignment.right
        firstLetter.textColor = UIColor.white
        firstLetter.adjustsFontSizeToFitWidth = true
        firstLetter.text = "A"
        self.addSubview(firstLetter)
        
        let secondLetter = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 35, height: 40))
        secondLetter.center = CGPoint.init(x: self.center.x, y: self.center.y-10)
        secondLetter.font = UIFont.init(name: "Pixel-Art", size: 38)
        secondLetter.backgroundColor = UIColor.clear
        secondLetter.textAlignment = NSTextAlignment.center
        secondLetter.textColor = UIColor.white
        secondLetter.adjustsFontSizeToFitWidth = true
        secondLetter.text = "A"
        self.addSubview(secondLetter)
        
        let thirdLetter = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        thirdLetter.center = CGPoint.init(x: self.center.x+42, y: self.center.y-10)
        thirdLetter.font = UIFont.init(name: "Pixel-Art", size: 38)
        thirdLetter.backgroundColor = UIColor.clear
        thirdLetter.textAlignment = NSTextAlignment.left
        thirdLetter.adjustsFontSizeToFitWidth = true
        thirdLetter.textColor = UIColor.white
        thirdLetter.text = "A"
        self.addSubview(thirdLetter)
        
        let endLetter = UILabel.init(frame: CGRect.init(x: 0, y: 0, width:43, height:20))
        endLetter.center = CGPoint.init(x: self.center.x+87, y: self.center.y-2)
        endLetter.font = UIFont.init(name: "Pixel-Art", size: 18)
        endLetter.backgroundColor = UIColor.clear
        endLetter.textAlignment = NSTextAlignment.left
        endLetter.textColor = UIColor.white
        endLetter.text = "end"
        self.addSubview(endLetter)
        
        let yourScoreLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 160, height: 40))
        yourScoreLabel.center = CGPoint.init(x: self.center.x, y: self.center.y + 50)
        yourScoreLabel.font = UIFont.init(name: "Pixel-Art", size: 16)
        yourScoreLabel.backgroundColor = UIColor.clear
        yourScoreLabel.textAlignment = NSTextAlignment.center
        yourScoreLabel.textColor = UIColor.white
        yourScoreLabel.adjustsFontSizeToFitWidth = true
        yourScoreLabel.text = "your score:"
        self.addSubview(yourScoreLabel)
        
        scoreLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 160, height: 40))
        scoreLabel.center = CGPoint.init(x: self.center.x, y: self.center.y + 70)
        scoreLabel.font = UIFont.init(name: "Pixel-Art", size: 22)
        scoreLabel.backgroundColor = UIColor.clear
        scoreLabel.textAlignment = NSTextAlignment.center
        scoreLabel.textColor = UIColor.white
        scoreLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(scoreLabel)
        
        labels.append(firstLetter)
        labels.append(secondLetter)
        labels.append(thirdLetter)
        labels.append(endLetter)

        selectLabel(label: firstLetter)
    }
    
    
    //
    // MARK : JOYSTICK DELEGATE METHODS
    //
    
    
    
    
    func joystickUpdatedDirection(sender: AnyObject)
    {
        guard let stick = sender as? SKJoystick else { return }
        let now = NSDate().timeIntervalSince1970
        if (latestInputTime + 1) >= now {return}
        latestInputTime = now
        
        let dir = stick.direction
        
        if dir == Sense.RIGHT
        {
            self.goToNextLabel()
        }
        if dir == Sense.LEFT
        {
            self.goToPrevLabel()
        }
        if dir == Sense.UP
        {
            self.goToPrevLetter()
        }
        if dir == Sense.DOWN
        {
            self.goToNextLetter()
        }
    }
    
    func joystickReleased(sender: AnyObject)
    {
        latestInputTime = 0
    }
    
    func joystickButtonPressed(sender: AnyObject)
    {
        if (self.labels.count - 1) == self.currentLabelIndex
        {
            let userName = self.getCurrentName()
            guard let _ = delegate?.savePlayerScore(points: score, nickName: userName) else { return }
        }
        else
        {
            self.goToNextLabel()
        }
    }
    
    
    
    
    
    
    
    //
    // MARK : UTILITY METHODS
    //
    
    func goToNextLetter()
    {        
        changeLetter(mod:1)
    }
    
    func goToPrevLetter()
    {
        changeLetter(mod:-1)
    }
    
    func goToNextLabel()
    {        
        changeLabel(mod:1)
    }
    
    func goToPrevLabel()
    {
        changeLabel(mod:-1)
    }
    
    func changeLabel(mod:Int)
    {
        currentLabelIndex = currentLabelIndex + mod
        if currentLabelIndex < 0 { currentLabelIndex = labels.count-1 }
        if currentLabelIndex > labels.count - 1 { currentLabelIndex = 0 }
        let label = labels[currentLabelIndex]
        selectLabel(label: label)
    }
    
    func changeLetter(mod:Int)
    {
        let currentLabel = labels[currentLabelIndex]
        guard let currentLetter = currentLabel.text else {return}
        guard let currentIndex = letters.index(of: currentLetter) else {return}
        var newIndex = currentIndex + mod
        if newIndex < 0 { newIndex = letters.count - 1 }
        if newIndex > letters.count - 1 { newIndex = 0 }
        let newLetter = letters[newIndex]
        currentLabel.text = newLetter
    }

    func selectLabel(label:UILabel)
    {
        removeAllAnimations()
        
        UIView.animate(withDuration: TimeInterval(0.8), delay: 0, options: [.repeat], animations:
        {
            label.alpha = 0.5
        },
        completion:
        {
            (completed) in
            print("button animation stops")
        })
    }
    
    func removeAllAnimations()
    {
        for label in labels
        {
            label.layer.removeAllAnimations()
            label.alpha = 1.0
        }
    }
    
    func getCurrentName() -> String
    {
        var currentName = ""
        for label in labels
        {
            guard let l = label.text else { break }
            if l == "end" {break}
            currentName = "\(currentName)\(l)"
        }
        return currentName
    }
    
    func setScore(score:Int)
    {
        self.score = score
        self.scoreLabel.text = "\(score)"
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}
