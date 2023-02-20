//
//  IntroViewController.swift
//  demo
//
//  Created by Sena Uzun on 18.02.2023.
//

import UIKit

class IntroViewController: UIViewController {

    // MARK : - Intro Screen
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func showMoviesButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toMoviesList", sender: nil)
    }
    
    @IBAction func addMovieButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toCreateMovieVC", sender: nil)
    }
}
