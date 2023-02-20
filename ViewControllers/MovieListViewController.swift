//
//  ViewController.swift
//  demo
//
//  Created by Sena Uzun on 18.02.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class MovieListViewController: UIViewController,UICollectionViewDataSource , UICollectionViewDelegate {
    
    // MARK : - Movie List Screen
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
  
    var movieArray = [Movie]()
    var movieToPass: Movie?

    //Grid View
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.movieToPass = movieArray[indexPath.row]
        guard let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsVC") as? MovieDetailsViewController else { return }

        guard let movie = self.movieToPass else { return }
        destinationVC.movie = movie
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(movieArray.count , 6)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCollectionViewCell
        cell.movieImages.sd_setImage(with: URL(string: self.movieArray[indexPath.row].imageUrlArray))
        return cell
    }
  
    //Get data from firebase
    func getDataFromFirestore(){
        //Firebase Integration
        
        let firestoreDatabase = Firestore.firestore()
        //Movies order by date.Newly created movie appears on the first 
        firestoreDatabase.collection("Movies").order(by: "date" , descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.movieArray.removeAll(keepingCapacity: false)
                    
                    for document in  snapshot!.documents {
                        let documentID = document.documentID
                                            
                        let movie = Movie(
                            id: document.documentID,
                            imageUrlArray: document.get("imageUrl") as? String ?? "imageUrl",
                            title: document.get("title") as? String ?? "title",
                            year: document.get("releaseYear") as? String ?? "year",
                            genre: document.get("Genre") as? String ?? "genre",
                            shortDesc: document.get("shortDescription") as? String ?? "shortDesc",
                            longDesc: document.get("longDescription") as? String ?? "longDesc"
                        )
     
                        self.movieArray.append(movie)
                    }
                    //refresh view
                    self.movieCollectionView.reloadData()

                }
            }
        }
    }

      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Movies"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        //Navigation Controller Items
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        
        getDataFromFirestore()
    }
    
    @objc func addButtonClicked(){
        self.performSegue(withIdentifier: "fromMovieListToCreateVC", sender: nil)

    }
    @objc func backButtonClicked(){
        self.dismiss(animated: true)
    }
    @objc func addCellButtonClicked(){
        self.performSegue(withIdentifier: "fromMovieListToCreateVC", sender: nil)

    }
    
    //Represent to empty slot that segue to create movie screen
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footercell = movieCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footercell", for: indexPath) as! MovieCollectionViewCell
        return footercell
    }
    
    @IBAction func emptySlotClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "fromMovieListToCreateVC", sender: nil)
    }
    

}

