//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Иван Базаров on 30.09.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //print(self.editImageButton.frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //print(self.editImageButton.frame)
        //Невозможно распечатать свойство frame т.к в данном методе эта кнопка еще не инициализирована и содержит nil, что приводит к краху приложения при попытке ее распечатать
        
    }
    
    
    @IBAction func editImageAction(_ sender: Any) {
        print("Выбери изображение профиля")
        
        let alertController = UIAlertController(title: "Выберите изображение для профиля", message: "", preferredStyle: .actionSheet)
        let addPhotoAction = UIAlertAction(title: "Установить из галереи", style: .default) { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let makePhotoAction = UIAlertAction(title: "Сделать фото", style: .default) { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action: UIAlertAction) in
        }
        
        alertController.addAction(addPhotoAction)
        alertController.addAction(makePhotoAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImageView.layer.masksToBounds = true
        self.editImageButton.layer.masksToBounds = true
        self.editButton.layer.masksToBounds = true
        
        self.profileImageView.layer.cornerRadius = 40.0
        
        self.editImageButton.imageView?.contentMode = .scaleAspectFit
        self.editImageButton.imageEdgeInsets = UIEdgeInsets.init(top: 17.0, left: 17.0, bottom: 17.0, right: 17.0)
        self.editImageButton.layer.cornerRadius = self.editImageButton.frame.size.width / 2
        self.editImageButton.backgroundColor = UIColor(red: 0x3F, green: 0x78, blue: 0xF0)
        
        self.editButton.layer.cornerRadius = 15.0
        self.editButton.layer.borderWidth = 1.0
        print("Frame in viewDidLoad: ", self.editButton.frame)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("Frame in viewDidAppear: ", self.editButton.frame)
        //В данном случае "frame" отличается, потому что метод viewDidAppear вызывается после вычисления позиции и размера всех вьюх, а метод viewDidLoad - до.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        self.profileImageView.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        self.profileImageView.contentMode = UIView.ContentMode.scaleAspectFill
        self.profileImageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
