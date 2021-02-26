//
//  AddNewGameViewControllerTableViewController.swift
//  GameboardCollection
//
//  Created by Владислав on 18.02.2021.
//

import UIKit
import Cosmos

class AddNewGameViewControllerTableViewController: UITableViewController {
    
    var currentGame: Game! //для передачи объекта с типо Game из ячейки в карточку игры для редактирования
    
    var imageIsChanged = false //логическое свойство в классе - необходимо для показа дефолтного изображения в основной таблице игр (пока не добавлено новое - смена значения подставляется в методе imagePickerController)
    
    var currentRating = 0.0
    
    //ячейки статичны и мы можем привязать изображение в контроллер
    @IBOutlet weak var enterGameimage: UIImageView!
    @IBOutlet weak var saveCheckButton: UIBarButtonItem!
    
    @IBOutlet weak var enterName: UITextField!
    @IBOutlet weak var enterInfo: UITextField!
    @IBOutlet weak var enterNumber: UITextField!
    @IBOutlet weak var enterType: UITextField!
    @IBOutlet weak var ratingControl: RatingStack!
    @IBOutlet weak var cosmosRating: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //убираем разлиновку
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1)) //убираем последний разделитель в ячейке таблицы
        saveCheckButton.isEnabled = false //отключаем кнопку - пока поле (название игры не будет заполненно)
        //логика доступности кнопки сохранения: каждый раз будет вызваться метод при остследивании изменений поля для введения названия игры
        enterName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        editScreen() //запуск метода открытия экрана редактирования по нажатию на ячейку
        
        cosmosRating.settings.fillMode = .half
        cosmosRating.didTouchCosmos = { rating in
            
            self.currentRating = rating
        }
    }
    
    //MARK: - Table view delegate отработка нажатия на ячейку (картинка и 4 поля текста)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //При тапе закрывам клавиатуру при надатии на любую ячейку кроме картинки (для нее отдеьный вызов камеры или библиотеки фото)
        if indexPath.row == 0 {
            
            let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet) //параметр алерт контроллера при тапе на ячейку с картинкой
            actionAlert.view.tintColor = .black
            
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.imagePicker(source: .camera) //определяем место
            }
            // camera.setValue(cameraImage, forKey: "image") //устанавливаем изображения в алерт контроллер
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.imagePicker(source: .photoLibrary) //определяем место
            }
            // photo.setValue(photoImage, forKey: "Image") //устанавливаем изображения в алерт контроллер
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionAlert.addAction(camera)
            actionAlert.addAction(photo)
            actionAlert.addAction(cancel)
            
            present(actionAlert, animated: true) // вызов алерт контроллера
            
        } else {
            view.endEditing(true)
        }
    }
    
    //MARK: -  метод позволящий соранить и добавить заполенные поля в метод класса (Game) - вызываться метод будет в классе mainTableViewController
    func saveGame() {
        
        //условие при котором мы устанавлияваем дефолтное изображение в основной таблице
        var image: UIImage?
        
        if imageIsChanged {
            image = enterGameimage.image
        } else {
            image = #imageLiteral(resourceName: "exampleImageTest")
        }
        
        //вспомогательное свойство imageData для конвертации
        let imageData = image?.pngData()
        
        let newGame = Game(gameName: enterName.text!,
                           gameInfo: enterInfo.text,
                           gameScore: enterNumber.text,
                           imageData: imageData,
                           gameType: enterType.text,
                           rating: currentRating)
        
        //условие для определения в каком режиме сейчас находится контроллер добавления/редактирования ячейки
        if currentGame != nil {
            try! realm.write{
                currentGame?.gameName = newGame.gameName
                currentGame?.gameInfo = newGame.gameInfo
                currentGame?.gameScore = newGame.gameScore
                currentGame?.imageData = newGame.imageData
                currentGame?.gameType = newGame.gameType
                currentGame?.rating = newGame.rating
            }
        } else {
            StorageDataManager.saveObject(newGame)
        }
    }
    //MARK: - метод который позволит открывать не страницу добавления новой ячейки, а страницу редактирования контента ячейки по который сделали тап
    private func editScreen() {
        if currentGame != nil { //нам необходим функционал только когда currentGame не принимает в себя новые данные/ аписи а значит исходим из условия что он не равен nil
            
            editNavigationBar()
            imageIsChanged = true // фикс бага - лечит сброс картинки при внесении изменений
            
            guard let data = currentGame?.imageData, let image = UIImage(data: data) else { return }
            
            enterName.text = currentGame?.gameName
            enterInfo.text = currentGame?.gameInfo
            enterNumber.text = currentGame?.gameScore
            enterGameimage.image = image
            enterGameimage.contentMode = .scaleAspectFill //добавляем для корректного отображения изоюражения при передаче из ячейки
            enterType.text = currentGame?.gameType
            cosmosRating.rating = currentGame.rating
        }
    }
    
    //MARK: - метод работы верхнего бара кнопки сохранить и назад в случаи режима редактирования ячейки
    private func editNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem { //настройки параметров кнопки назад в контроллрее навигации при редактировании ячейки
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentGame?.gameName //обязательно поле имя (всегда заполнено - передает в заголовок название игры при переходе)
        saveCheckButton.isEnabled = true
    }
    
    @IBAction func cancelAction(_sender: Any) {
        dismiss(animated: true)
    }
}

//MARK: - делегат расширения класса поля ввода для клавиатуры
extension AddNewGameViewControllerTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textFiled: UITextField) -> Bool {
        textFiled.resignFirstResponder()
        return true
    }
    
    //метод который следит за состоянием поля - ввода названия игры
    @objc private func textFieldChanged() {
        
        if enterName.text?.isEmpty == false {
            saveCheckButton.isEnabled = true
        } else {
            saveCheckButton.isEnabled = false
        }
    }
}

//MARK: - расширение для работы с изображениями (доступ камера и библиотека)
extension AddNewGameViewControllerTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true //позволяет пользователю отредактировать изображение по контуру
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil) //вызываем контроллер
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //присваиваем параметры согласно документации по ключу
        enterGameimage.image = info[.editedImage] as? UIImage //присваиваем отредактированные (под трафарет) изоражение нашему аутлету
        enterGameimage.contentMode = .scaleAspectFill
        enterGameimage.clipsToBounds = true //обрезка по границе
        imageIsChanged = true
        dismiss(animated: true) //закрываем контроллер по выполнению
    }
}
