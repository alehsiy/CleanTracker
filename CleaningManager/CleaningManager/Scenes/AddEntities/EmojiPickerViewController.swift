//
//  EmojiPickerViewController.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 04.10.2025.
//

import UIKit

class EmojiPickerViewController: UIViewController {

    var onEmojiSelected: ((String) -> Void)?

    private let emojis: [String] = [
        // MARK: - Бытовые предметы и мебель
            "🛋️", "🪑", "🛏️", "🚪", "🪟", "🖼️", "🧸", "📚", "📦", "🏺", "🕰️", "🪞", "🧳",

            // MARK: - Уборка и инструменты
            "🧹", "🧼", "🧽", "🪣", "🧤", "🧺", "🧻", "🧴", "🪒", "🗑️", "♻️", "🛠️", "🔧",
            "🔨", "🪓", "🔩", "⚙️", "🪜", "🧯", "🔑", "💡", "🔦", "🕯️",

            // MARK: - Кухня и посуда
            "🍽️", "🍴", "🔪", "🥄", "🍳", "🥣", "🫖", "☕", "🧊", "🚰",

            // MARK: - Одежда и аксессуары
            "👕", "👖", "👗", "🧦", "🧥", "🧣", "👟", "👞", "👠", "👢", "👒", "🧢", "👓",
            "🕶️", "💍", "👜", "🎒", "🌂",

            // MARK: - Растения и сад
            "🪴", "🌲", "🌳", "🌴", "🌱", "🌿", "🍀", "🍁", "🍂", "🍃", "🌹", "🌷", "🌸",
            "🌼", "🌻", "🌵",

            // MARK: - Животные
            "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐨", "🐯", "🦁", "🐮", "🐷",
            "🐸", "🐵", "🐔", "🐧", "🐦", "🐤", "🦆", "🦉", "🦇", "🐗", "🐴",
            "🦄", "🐝", "🦋", "🐌", "🐞", "🐜", "🕷️", "🐢", "🐍", "🦎", "🦖", "🦕",
            "🐡", "🐠", "🐟", "🐅", "🐆", "🐄",
            "🐎", "🐖", "🐏", "🐑", "🦙", "🐐", "🦌", "🐕", "🐩", "🦮", "🐕‍🦺", "🐈", "🐈‍⬛",
            "🐓", "🦃", "🦤", "🦚", "🦜", "🦢", "🦩", "🕊️", "🐇", "🦝", "🦦",
             "🐁", "🐀", "🐿️", "🦔",

            // MARK: - Транспорт и техника
            "🚗", "🚕", "🚙", "🚌", "🚐", "🚛", "🚜", "🏎️", "🏍️", "🛵", "🚲", "🛴", "✈️",
            "🚀", "🚢", "⛵", "🚤", "🚂", "🚁", "📱", "💻", "⌨️", "🖥️", "🖨️", "🖱️", "📷",
            "📹", "🎥", "📞", "☎️", "📺", "📻", "🎙️", "⌚", "🔋", "🔌",

            // MARK: - Спорт и хобби
            "⚽", "🏀", "🏈", "⚾", "🎾", "🏐", "🎱", "🏓", "🏸", "🏒", "⛳", "🏹", "🎣",
            "🥊", "🛹", "⛸️", "🎨", "🎬", "🎤", "🎧", "🎼", "🎹", "🥁", "🎷", "🎺", "🎸",
            "🪕", "🎻", "🎲", "♟️", "🎯", "🎳", "🎮", "🧩"
    ]

    private let itemsPerRow = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
    }

    private func setupScrollView() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 10
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(mainStack)

        let numberOfRows = Int(ceil(Double(emojis.count) / Double(itemsPerRow)))
        for i in 0..<numberOfRows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 10

            for j in 0..<itemsPerRow {
                let index = i * itemsPerRow + j
                if index < emojis.count {
                    let button = UIButton(type: .system)
                    button.setTitle(emojis[index], for: .normal)
                    button.titleLabel?.font = .systemFont(ofSize: 32)
                    button.backgroundColor = .systemGray6
                    button.layer.cornerRadius = 4
                    button.addTarget(
                        self,
                        action: #selector(emojiTapped(_:)),
                        for: .touchUpInside
                    )
                    rowStack.addArrangedSubview(button)
                } else {
                    rowStack.addArrangedSubview(UIView())
                }
            }
            mainStack.addArrangedSubview(rowStack)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            scrollView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            mainStack.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor,
                constant: 20
            ),
            mainStack.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor,
                constant: -10
            ),
            mainStack.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor,
                constant: 10
            ),
            mainStack.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor,
                constant: -10
            ),

            mainStack.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor,
                constant: -20
            ),
        ])
    }

    @objc
    private func emojiTapped(_ sender: UIButton) {
        guard let emoji = sender.currentTitle else { return }
        onEmojiSelected?(emoji)
        sender.backgroundColor = .lightGray
        dismiss(animated: true, completion: nil)
    }
}
