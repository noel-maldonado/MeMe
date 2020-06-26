//
//  DetailViewController.swift
//  MeMe
//
//  Created by Noel Maldonado on 6/23/20.
//  Copyright © 2020 Noel Maldonado. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    
    
    var meme: MeMe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memeImageView.image = meme!.meme
        // Do any additional setup after loading the view.
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       
    }
}
