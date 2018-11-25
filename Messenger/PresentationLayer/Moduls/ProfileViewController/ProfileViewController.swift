//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Иван Базаров on 30.09.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var saveUsingCoreData: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    var profileInteractor: IProfileInteractor!
    var assembly: IPresentationAssembly!
    var isSavingData: Bool = false
    var isPhotoSelected: Bool = false
    var isEditingProfile: Bool = false {
        didSet {
            editImageButton.isHidden = !editImageButton.isHidden
            nameTextField.isHidden = !nameTextField.isHidden
            saveUsingCoreData.isHidden = !saveUsingCoreData.isHidden
            descriptionTextField.isHidden = !descriptionTextField.isHidden
            if isEditingProfile {
                saveUsingCoreData.isEnabled = false
                editButton.setTitle("Отменить редактирование", for: .normal)
                nameLabel.text =  "Имя пользователя"
                descriptionLabel.text = "О себе"
                nameTextField.placeholder = "Укажите свое имя"
                descriptionTextField.placeholder = "Расскажите о себе"
                nameTextField.text = profileInteractor.name
                descriptionTextField.text = profileInteractor.description
            } else {
                editButton.setTitle("Редактировать", for: .normal)
                updateProfileInfo()
            }
        }
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveUserProfile()
    }
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func nameEditingEnd(_ sender: UITextField) {
        saveButtonsControl()
    }
    @IBAction func descriptionEditingEnd(_ sender: UITextField) {
        saveButtonsControl()
    }
    @IBAction func editButtonTapped(_ sender: UIButton) {
        isEditingProfile = !isEditingProfile
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //print(self.editImageButton.frame)
        //Невозможно распечатать свойство frame т.к в данном методе эта кнопка еще не инициализирована и содержит nil, что приводит к краху приложения при попытке ее распечатать
    }
    @IBAction func editImageAction(_ sender: UITapGestureRecognizer) {
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
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let downloadImageAction = UIAlertAction(title: "Загрузить фото из интернета", style: .default) { (action: UIAlertAction) in
            self.performSegue(withIdentifier: "downloadImages", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action: UIAlertAction) in
        }
        alertController.addAction(addPhotoAction)
        alertController.addAction(makePhotoAction)
        alertController.addAction(downloadImageAction)
        alertController.addAction(cancelAction)
        if isPhotoSelected {
            let deletePhotoAlertAction = UIAlertAction(title: "Удалить фотографию", style: .destructive) {(action: UIAlertAction) in
                self.profileImageView.image = UIImage(named: "placeholder-user")
                self.isPhotoSelected = false
                self.saveButtonsControl()
            }
            alertController.addAction(deletePhotoAlertAction)
        }

        self.present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupKeyboard()
        loadUserProfile()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.profileImageView.layer.cornerRadius = 40
    }
    func setupKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(gesture:)))
        view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func setupViews() {
        self.profileImageView.layer.masksToBounds = true
        self.editImageButton.layer.masksToBounds = true
        self.editButton.layer.masksToBounds = true
        self.saveUsingCoreData.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = 40.0
        self.profileImageView.contentMode = .scaleAspectFill
        self.editImageButton.imageView?.contentMode = .scaleAspectFit
        self.editImageButton.imageEdgeInsets = UIEdgeInsets.init(top: 17.0, left: 17.0, bottom: 17.0, right: 17.0)
        self.editImageButton.layer.cornerRadius = self.editImageButton.frame.size.width / 2
        self.editImageButton.backgroundColor = UIColor(red: 0x3F, green: 0x78, blue: 0xF0)
        self.editButton.layer.cornerRadius = 15.0
        self.editButton.layer.borderWidth = 1.0
        self.saveUsingCoreData.layer.cornerRadius = 15
        self.saveUsingCoreData.layer.borderWidth = 1.0
    }
    override func viewDidAppear(_ animated: Bool) {
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
        saveUsingCoreData.isEnabled = true
        isPhotoSelected = true
        dismiss(animated: true, completion: nil)
    }
    private func saveButtonsControl() {
        if (!isSavingData && (nameTextField.text != "") && ((nameTextField.text != profileInteractor.name) || (descriptionTextField.text != profileInteractor.description || (profileImageView.image!.jpegData(compressionQuality: 1.0) != profileInteractor.imageData)))) {
            saveUsingCoreData.isEnabled = true
        }
    }
    @objc func hideKeyboard(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    private func loadUserProfile() {
        editButton.isHidden = true
        activityIndicatorView.startAnimating()
        profileInteractor.loadProfile {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            self.editButton.isHidden = false
            self.isPhotoSelected = UIImage(named: "placeholder-user")!.jpegData(compressionQuality: 1.0) != self.profileInteractor.imageData
            self.updateProfileInfo()
        }
    }

    private func saveUserProfile() {
        isSavingData = true
        saveUsingCoreData.isEnabled = false
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        guard let name = nameTextField.text, let description = descriptionTextField.text, let image = profileImageView.image else { return }
        profileInteractor.saveProfile(name: name, description: description, imageData: image.jpegData(compressionQuality: 1.0)!) { (error) in
            if error == nil {
                let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ок", style: .default) { action in
                    UserDefaults.standard.set(name, forKey: "name")
                    if self.isEditingProfile {
                        self.isEditingProfile = false
                    } else {
                        self.updateProfileInfo()
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
                let repeatAction = UIAlertAction(title: "Повтор", style: .default) { action in
                    self.saveUserProfile()
                }
                alert.addAction(okAction)
                alert.addAction(repeatAction)
                self.present(alert, animated: true, completion: nil)
            }
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            self.saveUsingCoreData.isEnabled = true
            self.isSavingData = false
        }
    }
    private func updateProfileInfo() {
        nameLabel.text = profileInteractor.name
        descriptionLabel.text = profileInteractor.description
        profileImageView.image = UIImage(data: profileInteractor.imageData)
    }
    @objc private func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        let keyboardInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = keyboardInsets
        scrollView.scrollIndicatorInsets = keyboardInsets
    }
    @objc private func keyboardWillHidden() {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "downloadImages" {
            guard let navigationController = segue.destination as? UINavigationController,
                let loaderImageVC = navigationController.topViewController as? DownloadImageViewController else {
                    super.prepare(for: segue, sender: sender)
                    return
            }
            loaderImageVC.assembly = assembly
            let imageLoaderInteractor = assembly.getImageLoaderInteractor()
            imageLoaderInteractor.delegate = loaderImageVC
            loaderImageVC.imageLoaderInteractor = imageLoaderInteractor
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {
        saveButtonsControl()
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
