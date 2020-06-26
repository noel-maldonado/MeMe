//
//  SentMemesCollectionViewController.swift
//  MeMe
//
//  Created by Noel Maldonado on 6/22/20.
//  Copyright © 2020 Noel Maldonado. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var memes = appDelegate.memes
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let space:CGFloat = 3.0
//        let dimension = (view.frame.size.width - (2 * space)) / 3.0
//        flowLayout.minimumInteritemSpacing = space
//        flowLayout.minimumLineSpacing = space
//        flowLayout.itemSize = CGSize(width: 150, height: 150)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memes = appDelegate.memes
        collectionView.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeMeCollectionViewCell", for: indexPath) as! MeMeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]

        // Set image
        cell.MeMeImageView.image = meme.meme

        return cell
    }
    
    
    @IBAction func newMeMeBarButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newView = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        newView.modalPresentationStyle = .fullScreen
        self.present(newView, animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailView = storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailView.meme = self.memes[indexPath.row]
        navigationController!.pushViewController(detailView, animated: true)
    }
    
}
