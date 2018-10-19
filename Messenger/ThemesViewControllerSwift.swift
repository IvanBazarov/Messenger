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
    var onChangeTheme: ((UIColor) -> Void)?
 
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBAction func themesTapped(_ sender: UIButton) {
        var themeColor = model.defaultColor!
        
        switch (sender.tag) {
        case 1:
            themeColor = self.model.theme1
        case 2:
            themeColor = self.model.theme2
        case 3:
            themeColor = self.model.theme3
        default:
            break
        }
        onChangeTheme?(themeColor)
        setUpTheme(themeColor)
        setUpNavBar(themeColor)
        saveTheme(themeColor)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.color(forKey: "theme") != nil {
            self.view.backgroundColor = UserDefaults.standard.color(forKey: "theme")
        }
    }
    
    func setUpNavBar(_ theme: UIColor) {
        UINavigationBar.appearance().backgroundColor = theme
        
    }
    
    func saveTheme(_ theme: UIColor) {
        UserDefaults.standard.set(theme, forKey: "theme")
    }
    
    func setUpTheme(_ theme: UIColor){
        self.view.backgroundColor = theme
        self.navigationController?.navigationBar.backgroundColor = theme
        /*let vc = ConversationsListViewController()
        vc.changeThemeWithClosure(theme)*/
        
    }
}


