//
//  GameModel.swift
//  GameboardCollection
//
//  Created by Владислав on 18.02.2021.
//

import RealmSwift

class Game: Object {
    
    @objc dynamic var gameName = ""
    @objc dynamic var gameInfo: String? //все поля кроме названия игры делает опциональными
    @objc dynamic var gameScore: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var gameType: String?
    @objc dynamic var rating = 0.0
    
    //проверить на ошибкb i,age может неправильно тянуть
    convenience init(gameName: String, gameInfo: String?, gameScore: String?, imageData: Data?, gameType: String?, rating: Double) {
        self.init()
        self.gameName = gameName
        self.gameInfo = gameInfo
        self.gameScore = gameScore
        self.imageData = imageData
        self.gameType = gameType
        self.rating = rating
    }
}
