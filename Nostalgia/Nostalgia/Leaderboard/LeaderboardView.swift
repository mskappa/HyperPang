//
//  LeaderboardView.swift
//  Nostalgia
//
//  Created by Vincenzo Ajello on 05/03/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class LeaderboardView: UIView, UITableViewDelegate, UITableViewDataSource
{
    var coreData:CoreDataDefaultStorage!
    var scores:[Scores] = []
    var tableview:UITableView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        let headerLabel = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: self.frame.size.width, height: 30))
        headerLabel.font = UIFont.init(name: "Pixel-Art", size: 22)
        headerLabel.textAlignment = .center
        headerLabel.text = "Leaderboard"
        headerLabel.textColor = UIColor.white
        self.addSubview(headerLabel)
        
        tableview = UITableView.init(frame: CGRect.init(x: 15, y: 50, width: self.frame.size.width-30, height: self.frame.size.height-65))
        tableview.register(LeaderboardCell.self, forCellReuseIdentifier: "LeaderboardCell")
        //tableview.isScrollEnabled = false
        tableview.backgroundColor = UIColor.clear
        tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        tableview.dataSource = self
        tableview.delegate = self
        
        tableview.layer.borderWidth = 2
        tableview.layer.borderColor = UIColor.white.cgColor
        tableview.layer.cornerRadius = 6
        
        self.addSubview(tableview)
        
        self.coreData = initCoreData()
        self.refreshData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if scores.count > 10
        {return 10}
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
        cell.setRank(rank: indexPath.row)
        cell.playerName.text = scores[indexPath.row].nickname
        cell.playerScore.text = "\(scores[indexPath.row].score)"
        return cell
    }
    
    func refreshData()
    {
        self.scores = []
        self.tableview.reloadData()
        let entries:[Scores] = try! self.coreData.fetch(FetchRequest<Scores>().sorted(with: "score", ascending: false))
        for entry in entries
        {self.scores.append(entry)}
        self.tableview.reloadData()
    }
    
    func initCoreData() -> CoreDataDefaultStorage
    {
        let store = CoreDataStore.named("NostalgiaData")
        let bundle = Bundle(for: self.classForCoder)
        let model = CoreDataObjectModel.merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        return defaultStorage
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}

}
