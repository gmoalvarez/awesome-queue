//
//  VisitDetailViewController.swift
//  FInalProject
//
//  Created by Guillermo on 12/2/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import UIKit

class VisitDetailViewController: UIViewController {

    var visit:Visit?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var reasonTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setOutlets()
    }
    
    func setOutlets() {
        guard let visit = visit else {
            print("No visit to show")
            return
            
        }
        
        nameTextLabel.text = "\(visit.firstName) \(visit.lastName)"
        reasonTextLabel.text = visit.reason
        profileImageView.image = visit.image
//        profileImageView.contentMode = .ScaleAspectFit
    }

    var image:UIImage? {
        get {
            return profileImageView.image
        }
        set {
            profileImageView.image = image
            if let constrainedView = profileImageView {
                if let newImage = newValue {
                    aspectRatioContraint = NSLayoutConstraint(item: constrainedView,
                        attribute: .Width,
                        relatedBy: .Equal,
                        toItem: constrainedView,
                        attribute: .Height,
                        multiplier: newImage.aspectRatio,
                        constant: 0)
                } else {
                    aspectRatioContraint = nil
                }
            }
        }
    }
    
    var aspectRatioContraint:NSLayoutConstraint? {
        willSet {
            if let existingConstraint = aspectRatioContraint {
                view.removeConstraint(existingConstraint)
            }
        }
        
        didSet {
            if let newConstraint = aspectRatioContraint {
                view.addConstraint(newConstraint)
            }
        }
    }
    


}

extension UIImage {
    var aspectRatio:CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}