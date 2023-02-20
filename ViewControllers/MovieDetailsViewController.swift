//
//  MovieDetailsViewController.swift
//  demo
//
//  Created by Sena Uzun on 18.02.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage


class MovieDetailsViewController: UIViewController {
    
    //MARK : - Movie Details Screen

    @IBOutlet weak var detailImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel?
    @IBOutlet weak var genreLabel: UILabel?
    @IBOutlet weak var shortDescLabel: UILabel?
    @IBOutlet weak var longDescLabel: UILabel?
    

    //Movie Model
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            
            //Execute code after delay
            //Carrying and parsing data
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                
                self.detailImageView?.sd_setImage(with: URL(string: movie.imageUrlArray))
                self.titleLabel?.text = movie.title
                self.yearLabel?.text = movie.year
                self.genreLabel?.text = movie.genre
                self.shortDescLabel?.text = movie.shortDesc
                self.longDescLabel?.text = movie.longDesc

            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        longDescLabel!.layer.borderColor = UIColor.white.cgColor
        longDescLabel!.layer.borderWidth = 1
        


    }


    
    @IBAction func editButtonClicked(_ sender: Any) {
        //self.performSegue(withIdentifier: "fromDetailsToEdit", sender: nil)
        guard let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "EditMovieVC") as? EditMovieViewController else { return }
        destinationVC.movie = movie
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    


}
