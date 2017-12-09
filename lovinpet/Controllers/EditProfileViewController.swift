//
//  EditProfileViewController.swift
//  lovinpet
//
//  Created by Hong Gao on 10/8/17.
//  Copyright © 2017 Hong Gao. All rights reserved.
//

import UIKit

protocol EditProtocal {
    func save(name: String, breed: String, age: String, gender: String, image: UIImage)
}

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var delegate: EditProtocal?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var BreedTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        avatarImageView.layer.masksToBounds = true
        avatarImageView.backgroundColor = UIColor.white
        avatarImageView.layer.borderColor = UIColor.gray.cgColor
        avatarImageView.layer.borderWidth = 1
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height / 2
        
        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarTapped(_:))))
    }
    
    @objc func avatarTapped(_ sender: Any) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        })
        
        let pickAction = UIAlertAction(title: "Pick a Photo", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imgPicker = UIImagePickerController()
                imgPicker.delegate = self
                imgPicker.sourceType = .photoLibrary
                imgPicker.allowsEditing = true
                self.present(imgPicker, animated: true, completion: {
                    
                })
            }
        })
        
        let takeAction = UIAlertAction(title: "Take a Photo", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imgPicker = UIImagePickerController()
                imgPicker.delegate = self
                imgPicker.sourceType = .camera
                imgPicker.allowsEditing = false
                self.present(imgPicker, animated: true, completion: {
                    
                })
            }
        })
        
        controller.addAction(pickAction)
        controller.addAction(takeAction)
        controller.addAction(cancelAction)
        self.present(controller, animated: true, completion: {
            
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = selectedImage
            avatarImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if nameTextField.text == nil || BreedTextField.text == nil || ageTextField.text == nil || self.genderTextField.text == nil || self.image == nil {
            return
        }
        
        self.delegate?.save(name: nameTextField.text!, breed: BreedTextField.text!, age: ageTextField.text!, gender: self.genderTextField.text!, image: self.image!)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

