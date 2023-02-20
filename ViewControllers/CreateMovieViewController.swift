//
//  CreateMovieViewController.swift
//  demo
//
//  Created by Sena Uzun on 18.02.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class CreateMovieViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    

    //  MARK : - Create Movie Screen
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var releaseYearText: UITextField!
    @IBOutlet weak var shortDescriptionText: UITextField!
    @IBOutlet weak var genreMenu: UITextField!
    @IBOutlet weak var LongDescriptionText: UITextView!
    
   //Release Year Picker
    var releaseYearList = [String]()
    var releaseYearsPicker = UIPickerView()
    let toolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        releaseYearsPicker.delegate = self
        releaseYearsPicker.dataSource = self
        
        releaseYearText.inputView = releaseYearsPicker
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonClicked))
        toolbar.items = [doneBtn]
        releaseYearText.inputAccessoryView = toolbar
        
        for i in stride(from: 1985, through: 2015, by: 1) {
            releaseYearList.append(String(i))
        }
        
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(closeButtonClicked))
        
        
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        LongDescriptionText.layer.cornerRadius = 5

    }
    
    
    @objc func doneButtonClicked() {
        
        let selectedYear = releaseYearList[releaseYearsPicker.selectedRow(inComponent: 0)]
        releaseYearText.text = selectedYear
        self.view.endEditing(true)
        
        
    }
    
    //Choose Image from photoLibrary
    @objc func chooseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController , animated: true , completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true , completion: nil)
    }
    
    @objc func closeButtonClicked(){
            self.dismiss(animated: true)
        }
   
    @IBAction func addMovieButtonClicked(_ sender: Any) {
        
        //Before the "add movie" control fields
        
        if titleText.text == "" || shortDescriptionText.text == "" || LongDescriptionText.text == "" || genreMenu.text == "" || releaseYearText.text == "" {
            makeAlert(titleInput: "Missing fields", messageInput: "All fields are required")
          
            if titleText.text!.count  < 3 {
                makeAlert(titleInput: "Create a valid title", messageInput: "Create a title with at least 3 characters.")
                
                if shortDescriptionText.text!.count < 3 {
                    makeAlert(titleInput: "Create a valid short description ", messageInput: "Create a short description with at least 3 characters.")
                    
                    if LongDescriptionText.text!.count < 10 {
                        makeAlert(titleInput: "Create a valid long description ", messageInput: "Create a long description with at least 10 characters.")
                    
                    }
                
                }
                
            }
        }
        
      else {
            
            let storage = Storage.storage()
            let storageReference = storage.reference()
            
            let mediaFolder = storageReference.child("media")
            
            if let data = imageView.image?.jpegData(compressionQuality: 0.5){
                
                let uuid = UUID().uuidString
                
                let imageReference = mediaFolder.child("\(uuid).jpg")
                imageReference.putData(data, metadata : nil) { metadata, error in
                    if error != nil {
                        self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                    }else{
                        imageReference.downloadURL { url, error in
                            if error == nil {
                                let imageUrl = url?.absoluteString
                                
                                
                                //DATABASE Configurations
                                
                                
                                let firestoreDatabase = Firestore.firestore()
                                
                                var firestoreReference : DocumentReference? = nil
                                
                                let firestoreMovie = ["imageUrl" : imageUrl! ,
                                                      "title" : self.titleText.text! ,
                                                      "releaseYear": self.releaseYearText.text! ,
                                                      "shortDescription" : self.shortDescriptionText.text! ,
                                                      "Genre" :self.genreMenu.text! ,
                                                      "longDescription" : self.LongDescriptionText.text! ,
                                                      "date" : FieldValue.serverTimestamp()]
                                
                                firestoreReference = firestoreDatabase.collection("Movies").addDocument(data: firestoreMovie , completion: { error in
                                    if error != nil {
                                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    }
                                    
                                    else {
                                        
                                        self.imageView.image = UIImage(named: "tapme.png")
                                        self.titleText.text = ""
                                        self.releaseYearText.text = ""
                                        self.shortDescriptionText.text = ""
                                        self.genreMenu.text = ""
                                        self.LongDescriptionText.text = ""
                                        
                                        
                                        self.performSegue(withIdentifier: "createMovieToMovieList", sender: nil)
                                        
                                    }
                                    
                                })
                            }
                        }                       
                    }
                }
            }
            
            
        }
    }
    
    //ReleaseYear Picker configurations
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return releaseYearList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return releaseYearList[row]
    }

    
    //Make Alert
    func makeAlert (titleInput: String , messageInput : String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
        
    }
}
