//
//  MainTableViewController.swift
//  GameboardCollection
//
//  Created by Владислав on 18.02.2021.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    
    
    //меняем создание элеменов массива на вызов вспомогательного метода из модели!
    //let newGameBoardArray = [Game(gameName: "Особняки безумия", gameinfo: "Уве Розенберг", gameScore: "100", gameiMage: "1")]
    let newGameBoardArray = Game.getGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newGameBoardArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        cell.gameName?.text = newGameBoardArray[indexPath.row].gameName
        cell.gameInfo?.text = newGameBoardArray[indexPath.row].gameinfo
        cell.gameScore?.text = newGameBoardArray[indexPath.row].gameScore
        cell.gameImage?.image =  UIImage(named: newGameBoardArray[indexPath.row].gameiMage)
        
        //скругляем изображения
        cell.gameImage?.layer.cornerRadius = cell.gameImage.frame.size.height / 2 //делим высоту картинки на два для скругления изображения
        cell.gameImage?.clipsToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
