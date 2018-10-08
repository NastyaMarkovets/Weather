//
//  ForecastViewController.swift
//  Weather
//
//  Created by Alexandr Yanski on 17.09.2018.
//  Copyright © 2018 Lonely Tree Std. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet weak var time1Label: UILabel!
    @IBOutlet weak var time2Label: UILabel!
    @IBOutlet weak var time3Label: UILabel!
    @IBOutlet weak var time4Label: UILabel!
    
    @IBOutlet weak var icon1View: UIImageView!
    @IBOutlet weak var icon2View: UIImageView!
    @IBOutlet weak var icon3View: UIImageView!
    @IBOutlet weak var icon4View: UIImageView!
    
    
    @IBOutlet weak var temp1Label: UILabel!
    @IBOutlet weak var temp2Label: UILabel!
    @IBOutlet weak var temp3Label: UILabel!
    @IBOutlet weak var temp4Label: UILabel!
    
    @IBOutlet weak var viewForecast: UIView!
    
    
    var time1: String!
    var time2: String!
    var time3: String!
    var time4: String!
    
    var icon1Image: UIImage!
    var icon2Image: UIImage!
    var icon3Image: UIImage!
    var icon4Image: UIImage!
    
    var temp1: String!
    var temp2: String!
    var temp3: String!
    var temp4: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewForecast.layer.cornerRadius = self.viewForecast.frame.size.width / 2
        self.viewForecast.clipsToBounds = true
        
        //Set animation view
        let scale = CGAffineTransform(scaleX: 0.0, y: 0.0)
        let translate = CGAffineTransform(translationX: 0.0, y: 500.0)
        viewForecast.transform = scale.concatenating(translate)
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            let scale = CGAffineTransform(scaleX: 1.0, y: 1.0)
            let translate = CGAffineTransform(translationX: 0.0, y: 0.0)
            self.viewForecast.transform = scale.concatenating(translate)
        }, completion: nil)
        
        time1Label.text = time1
        time2Label.text = time2
        time3Label.text = time3
        time4Label.text = time4
        
        icon1View.image = icon1Image
        icon2View.image = icon2Image
        icon3View.image = icon3Image
        icon4View.image = icon4Image 
        
        temp1Label.text = temp1
        temp2Label.text = temp2
        temp3Label.text = temp3
        temp4Label.text = temp4
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
