//
//  ThemesViewController.swift
//  Messenger
//
//  Created by Иван Базаров on 14.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit

class ThemesViewControllerSwift: UIViewController {
    
    let model = Themes()
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBAction func themesTapped(_ sender: UIButton) {
        var themeColor = model.defaultColor
        
        switch (sender.tag) {
        case 1:
            themeColor = self.model.theme1;
            break;
        case 2:
            themeColor = self.model.theme2;
            break;
        case 3:
            themeColor = self.model.theme3;
            break;
        default:
            break;
        }
        setUpTheme(themeColor ?? .white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UINavigationBar.appearance().backgroundColor
    }
    
    func setUpTheme(_ theme: UIColor){
        self.view.backgroundColor = theme
        self.navigationController?.navigationBar.backgroundColor = theme
        let vc = ConversationsListViewController()
        vc.changeThemeWithClosure(theme)
    }
    
}
