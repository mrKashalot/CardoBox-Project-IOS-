//
//  RatingStack.swift
//  GameboardCollection
//
//  Created by Владислав on 20.02.2021.
//

import UIKit

@IBDesignable class RatingStack: UIStackView {
    
    var rating = 0 {
        didSet {
            updateButtonsImageSelectionState()
        }
    }
    
    //MARK: - массив кнопок
    private var ratingButtons = [UIButton]()
    
    @IBInspectable var starSize: CGSize = CGSize(width: 30.0, height: 30.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 10 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: - инициализатор
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: - действия для кнопки
    @objc func ratingButtonPress(button: UIButton) {
        
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        
        let selecetedRating = index + 1
        
        if selecetedRating == rating {
            rating = 0
        } else {
            rating = selecetedRating
        }
    }
    
    //MARK: -  методы добавления кнопок
    private func setupButtons() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        //загрузка картинок
        let filleStar = UIImage(named: "starLight", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "starEmpty", in: bundle, compatibleWith: self.traitCollection)
        let highlitghtedStar = UIImage(named: "starFill", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount {
            
            let button = UIButton()
            
            //устанавляиваем картиинки к нопкам по состоянию
            button.setImage(emptyStar, for: .normal)
            button.setImage(filleStar, for: .selected)
            button.setImage(highlitghtedStar, for: .highlighted)
            button.setImage(highlitghtedStar, for: [.highlighted, .selected])
            
            //добавление констрейнтов
            button.translatesAutoresizingMaskIntoConstraints = false //отключает автоматические констрейнты при создании кнопки
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true //высота кнопки true - активирует констрейнты
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true //ширина кнопки
            
            //действие кнопка нажата
            button.addTarget(self, action: #selector(ratingButtonPress(button:)), for: .touchUpInside)
            
            //добавляем кнопку в стэк
            addArrangedSubview(button)
            
            //помещаем кнопку после каждой итерации цикла в массив!
            ratingButtons.append(button)
        }
        
        updateButtonsImageSelectionState()
    }
    
    //MARK: -  вспомогательный метод выставления каринки в соответсвии с рейтингом
    private func updateButtonsImageSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating //если индекс кнопки будет меньше рейтинга - то кнопка отобразит заполненную звезду
            
        }
    }
}
