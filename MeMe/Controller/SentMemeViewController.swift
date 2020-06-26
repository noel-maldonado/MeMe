//
//  SentMemeViewController.swift
//  MeMe
//
//  Created by Noel Maldonado on 5/26/20.
//  Copyright © 2020 Noel Maldonado. All rights reserved.
//

import UIKit

class SentMemeViewController: UITableViewController {
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var memes = appDelegate.memes
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memes = appDelegate.memes
        tableView.reloadData()
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
      }
      
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeMeCell", for: indexPath as IndexPath) as! MeMeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.memeImageView.image = meme.meme
        cell.cellLabel.text = "\(meme.topText!.prefix(8))...\(meme.bottomText!.suffix(8))"
        
        return cell
      }
    

    
    
    @IBAction func newMeMeBarButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newView = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        newView.modalPresentationStyle = .fullScreen
        self.present(newView, animated: true, completion: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailView = storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailView.meme = self.memes[indexPath.row]
        navigationController!.pushViewController(detailView, animated: true)
    }
    
    
}
