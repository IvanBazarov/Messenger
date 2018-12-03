//
//  TinkoffLogoNavigationController.swift
//  Messenger
//
//  Created by Иван Базаров on 03.12.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

class TinkoffLogoNavigation: UINavigationController {
    private var logoMaker: TinkoffLogoProtocol! = LogoView()
    override func viewDidLoad() {
        super.viewDidLoad()
        logoMaker.setupEmmitterLayer(view: view)
    }
}
