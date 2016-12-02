//
//  ImagesViewController.swift
//  testApp
//
//  Created by Engylizium on 30/11/16.
//  Copyright © 2016 Sobolev Peresvet. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView1.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imageView1.layer.borderWidth = 1
        imageView1.layer.borderColor = UIColor.lightGray.cgColor
        imageView1.contentMode = .scaleToFill
        imageView2.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imageView2.layer.borderWidth = 1
        imageView2.layer.borderColor = UIColor.lightGray.cgColor
        imageView2.contentMode = .scaleToFill
        imageView1.getImage(act: act1)
        imageView2.getImage(act: act2)
        
        self.view.addConstraint(NSLayoutConstraint(item: act1,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: imageView1,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: act1,
                                                    attribute: .centerY,
                                                    relatedBy: .equal,
                                                    toItem: imageView1,
                                                    attribute: .centerY,
                                                    multiplier: 1,
                                                    constant: 0))
        act1.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: act2,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: imageView2,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: act2,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: imageView2,
                                                   attribute: .centerY,
                                                   multiplier: 1,
                                                   constant: 0))
        act2.translatesAutoresizingMaskIntoConstraints = false

    }
    
    var win = 0
    var lose = 0
    var image1 = UIImage()
    var image2 = UIImage()
    var image3 = UIImage()
    
    
    @IBAction func showScoreButton(_ sender: UIBarButtonItem) {
        showScore(view: self.view)
    }
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var act1: UIActivityIndicatorView!
    @IBOutlet weak var act2: UIActivityIndicatorView!
    
    //- - - Tapping
    @IBAction func tapImage1(_ sender: UITapGestureRecognizer) {
        imageView1.getImage(act: act1)
        win += 1
    }
    @IBAction func tapImage2(_ sender: UITapGestureRecognizer) {
        imageView2.getImage(act: act2)
        lose += 1
    }

    
    //- - - Pinching
    @IBAction func pinchImage1(_ sender: UIPinchGestureRecognizer) {
        print("pinch 1")
    }
    @IBAction func pinchImage2(_ sender: UIPinchGestureRecognizer) {
        print("pinch 2")
    }
    
    
    
}




extension UIImageView {
    
    func getImage(act: UIActivityIndicatorView?) {
        act?.startAnimating()
        
        let url = URL(string: "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC")!
        
        let data = try? Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:[String:Any]]
        
        let imgURL = json["data"]?["image_original_url"] as! String
        
        URLSession.shared.dataTask(with: URL(string: imgURL)!) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = UIImage.gif(data: data)
                act?.stopAnimating()
            }
            }.resume()
        
    }
    
}

extension ImagesViewController: UIGestureRecognizerDelegate {
    
    func showScore(view: UIView){
        
        let score = UILabel()
        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let bg = UIVisualEffectView(effect: blur)
        
        score.layer.backgroundColor = UIColor.orange.cgColor
        score.layer.cornerRadius = 20
        score.textAlignment = .center
        
        score.text = "\(win)  :  \(lose)"
        score.font = UIFont.systemFont(ofSize: 45, weight: UIFontWeightLight)
        
        view.addSubview(bg)
        bg.addSubview(score)
        
        score.translatesAutoresizingMaskIntoConstraints = false
        
        bg.frame = view.bounds
        bg.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        bg.addConstraint(NSLayoutConstraint(item: score,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: bg,
                                            attribute: .height,
                                            multiplier: 0.25,
                                            constant: 0))
        bg.addConstraint(NSLayoutConstraint(item: score,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: bg,
                                            attribute: .width,
                                            multiplier: 0.5,
                                            constant: 0))
        bg.addConstraint(NSLayoutConstraint(item: score,
                                            attribute: .centerX,
                                            relatedBy: .equal,
                                            toItem: bg,
                                            attribute: .centerX,
                                            multiplier: 1,
                                            constant: 0))
        bg.addConstraint(NSLayoutConstraint(item: score,
                                            attribute: .centerY,
                                            relatedBy: .equal,
                                            toItem: bg,
                                            attribute: .centerY,
                                            multiplier: 1,
                                            constant: 0))

        let dismiss = UITapGestureRecognizer(target: bg, action: #selector(bg.removeFromSuperview))
        dismiss.delegate = self
        score.isUserInteractionEnabled = true
        score.addGestureRecognizer(dismiss)
    }
    
}
