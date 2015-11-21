//
//  QRGenViewController.swift
//  FInalProject
//
//  Created by Archie on 11/20/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import UIKit

protocol QRViewDelegate{
    func setQR(qr:UIImage?);
}

class QRGenViewController: UIViewController {

    @IBOutlet weak var qr: UIImageView!
    
    var qrImage:CIImage!
    var qrString:String?
    var delegate : QRViewDelegate! = nil
    var UIImageForQRReturn:UIImage?
    
    //this method gets called when the back button is pressed
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            //delegate method that will be located in the ProfessorCreateViewController
            delegate.setQR(qr.image)
        }
    }
    
    func stringMaker(){
        qrString = "Q.0|A12345678|37.33233|-122.0312"
        print("Level 1: \(qrString)")
    }
    
    func makeQR(){
        guard let qrInfo = qrString else{
            print("QR string failed to unwrap")
            return
        }
        let data = qrInfo.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)

        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            print ("filter not created")
            return
        }
    
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrImage = filter.outputImage
        
        print("Level 2!")
        displayQRCodeImage()
        
        
    }
    
    func displayQRCodeImage() {
        let scaleX = qr.frame.size.width / qrImage.extent.size.width
        let scaleY = qr.frame.size.height / qrImage.extent.size.height
        
        let transformedImage = qrImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        
        qr.image = UIImage(CIImage: transformedImage)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qr.layer.borderWidth = 1
        qr.layer.borderColor = UIColor.blackColor().CGColor
        stringMaker()
        makeQR()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
