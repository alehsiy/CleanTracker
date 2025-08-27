//
//  HomeViewController.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 19.08.2025.
//

import UIKit

final class HomeViewController: UIViewController, ModalScreenViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let buttonOpenModalScreen = UIButton(type: .system)
        buttonOpenModalScreen.setTitle("Add room", for: .normal)
        buttonOpenModalScreen.setTitleColor(.white, for: .normal)
        buttonOpenModalScreen.layer.cornerRadius = 15
        buttonOpenModalScreen.frame = CGRect(x: 100, y: 500, width: 200, height: 50)
        buttonOpenModalScreen.backgroundColor = .systemBlue
        
        view.addSubview(buttonOpenModalScreen)
        buttonOpenModalScreen.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc
    func buttonPressed() {
        let modalVC = ModalScreenViewController()
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.modalTransitionStyle = .crossDissolve
        modalVC.delegate = self
        present(modalVC, animated: true, completion: nil)
    }
    
    func modalScreenViewController(_ controller: ModalScreenViewController, didEnterName name: String, icon: String) {
        print("the modal window is closed")
    }
    
    func modalViewContollerDidClose(_ controller: ModalScreenViewController) {
        print("the modal window is closed")
    }
}
