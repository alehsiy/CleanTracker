//
//  ModalScreenHandler.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 05.10.2025.
//

import UIKit

protocol ModalScreenHandler: UIViewController {
    var selectedIcon: String? { get set }
    var iconsButtonsStackView: UIStackView { get }
    var moreEmojisButton: UIButton { get }
    
    func showEmojiPicker()
    func updateIconSelectionUI()
    func iconTapped(_ sender: UIButton)
}

extension ModalScreenHandler {
    
    func shared_showEmojiPicker() {
        let emojiPicker = EmojiPickerViewController()
        
        if let sheet = emojiPicker.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        emojiPicker.onEmojiSelected = { [weak self] emoji in
            self?.selectedIcon = emoji
            self?.updateIconSelectionUI()
        }
        
        present(emojiPicker, animated: true, completion: nil)
    }

    func updateIconSelectionUI() {
        var isCustomIconSelected = true

        for button in iconsButtonsStackView.arrangedSubviews.compactMap({ $0 as? UIButton }) {
            if button.currentTitle == selectedIcon {
                button.layer.borderColor = UIColor.systemBlue.cgColor
                button.layer.borderWidth = 2.0
                isCustomIconSelected = false
            } else {
                button.layer.borderWidth = 0
            }
        }

        if isCustomIconSelected && selectedIcon != nil {
            moreEmojisButton.layer.borderColor = UIColor.systemBlue.cgColor
            moreEmojisButton.layer.borderWidth = 2.0
            moreEmojisButton.setTitle(selectedIcon, for: .normal)
        } else {
            moreEmojisButton.layer.borderWidth = 0
            moreEmojisButton.setTitle("More Emojis", for: .normal)
        }
    }
    
    func shared_iconTapped(_ sender: UIButton) {
        selectedIcon = sender.currentTitle
        updateIconSelectionUI()
    }
}
