//
//  EditMovieViewController.swift
//  demo
//
//  Created by Sena Uzun on 19.02.2023.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseFirestore

class EditMovieViewController: UIViewController {

    //MARK : - Edit Movie Screen
    
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var editTitle: UITextField!
    @IBOutlet weak var editYear: UITextField!
    @IBOutlet weak var editShortDesc: UITextField!
    @IBOutlet weak var editLongDesc: UITextView!
    @IBOutlet weak var editGenre: UITextField!
    
    var movieArray = [Movie]()
    var movieToPass: Movie?
   
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }

            //Execute code after delay
            //Carrying and parsing data
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.editImageView?.sd_setImage(with: URL(string: movie.imageUrlArray))
                self.editTitle?.text = movie.title
                self.editYear?.text = movie.year
                self.editShortDesc?.text = movie.shortDesc
                self.editGenre?.text = movie.genre
                self.editLongDesc?.text = movie.longDesc
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Edit"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
     
        
        editTitle.isUserInteractionEnabled = false
        editYear.isUserInteractionEnabled = false
        
  
        editLongDesc.layer.cornerRadius = 5

    }
    

    //Carry selected movie to edit movie screen
    @IBAction func editMovieButtonClicked(_ sender: Any) {
        guard let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsVC") as? MovieDetailsViewController else { return }
        destinationVC.movie = movie
        self.navigationController?.pushViewController(destinationVC, animated: true)

    }
}
