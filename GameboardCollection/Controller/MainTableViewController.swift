//
//  MainTableViewController.swift
//  GameboardCollection
//
//  Created by Владислав on 18.02.2021.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {
    
    //MARK: - объект класса search controller - для посика по таблице
    private let searchController  = UISearchController(searchResultsController: nil)
    
    //MARK: - results является обьектом массива и мы можем использовать его как массив
    private var newGameBoardArray: Results<Game>!
    
    //MARK: - массив для отфильрованных данных
    private var filteredGames: Results<Game>!
    
    //MARK: - состояние строки - пустая / заполненная
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    //MARK: - еще одно вспомогательное свойство  - сработает в том случаи кгда запрос будет активирован
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //отображение заведенй на экране приложенияЖ делаем запрос
        newGameBoardArray = realm.objects(Game.self)
        
        //настройка контроллера поиcка
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //условие отображения количества ячеек либо отфильтрованный массив либо стандартный сохранненный
        if isFiltering {
            return filteredGames.count
        }
        return newGameBoardArray.count //делаем в слчаи когда массив пустой и игр добавленных нет
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let gameObject  = isFiltering ? filteredGames[indexPath.row] : newGameBoardArray[indexPath.row]
        
        cell.gameName?.text = gameObject .gameName
        cell.gameInfo?.text = gameObject .gameInfo
        cell.gameScore?.text = gameObject .gameScore
        cell.gameType?.text = gameObject .gameType
        cell.gameCellTestImage.image = UIImage(data: gameObject.imageData!)
        cell.cosmosRating.rating = gameObject.rating
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - метод удаления свайпов по ячейке
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let game = newGameBoardArray[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            StorageDataManager.deleteObject(game)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
    // MARK: - Navigation (переход по тапу по ячейке для редактирования текущих данных в ячейке с передачей данных уже из ячейки и карточку игры - новая запис. для передачи находится в контроллере новых игр перменная currentGame
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showID" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let game = isFiltering ? filteredGames[indexPath.row] : newGameBoardArray[indexPath.row]
            
            let newGameVC = segue.destination as! AddNewGameViewControllerTableViewController
            newGameVC.currentGame = game
        }
    }
    
    //MARK: - переделан в сохранение и передачу сохраненных данных в другой контроллер
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newGameVC = segue.source as? AddNewGameViewControllerTableViewController else { return }
        
        newGameVC.saveGame()
        tableView.reloadData()
    }
}

//MARK: - расширение для класса (для поиcка)
extension MainTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentSearchText(searchController.searchBar.text!) //значение опционально так как вызвется он только когда совершаем тап по строке поиска
    }
    
    private func filterContentSearchText(_ searchText: String) {
        
        //настройка фильтра  -  contains[c] - игнорирование регистра
        filteredGames = newGameBoardArray.filter("gameName CONTAINS[c] %@", searchText) //определили фильтрацию по имени игры
        tableView.reloadData()
    }
}
