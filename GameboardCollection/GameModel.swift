//
//  GameModel.swift
//  GameboardCollection
//
//  Created by Владислав on 18.02.2021.
//

import Foundation

struct Game {
    
    var gameName: String
    var gameinfo: String
    var gameScore: String
    var gameiMage: String
    
    //масси вспомогательной функци для генерации тестовых записей - что бы не писать каждую модель вручную
    static let gameBoardArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

    
    
    //вспомогательная функция для генерации обьектов в модели из массива
    static func getGame() -> [Game] {
        var newGameBoardArray = [Game]()
        
        for game in gameBoardArray {
            newGameBoardArray.append(Game(gameName: game, gameinfo: "Уве Розенберг", gameScore: "100", gameiMage: game))
        }
        return newGameBoardArray
    }
}
