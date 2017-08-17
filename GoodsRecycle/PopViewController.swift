//
//  PopViewController.swift
//  GoodsRecycle
//
//  Created by chang on 2017/8/9.
//  Copyright © 2017年 chang. All rights reserved.
//

import UIKit
import AlamofireImage

class PopViewController: UIViewController {
    
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imgPop: UIImageView!
    @IBOutlet weak var lblPopModel: UILabel!
    @IBOutlet weak var lblPopLocation: UILabel!
    
    var cellData: Good!

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(cellData)
        displayData()
        self.viewBack.layer.cornerRadius = 10
        self.viewBack.clipsToBounds = true
    }
    
    func displayData(){
        lblPopModel.text = cellData.model
        lblPopLocation.text = cellData.address
        if let img_url = URL(string: cellData.image)
        {
            imgPop.af_setImage(withURL: img_url)
        }else{
            imgPop.image = UIImage(named: "nsslsnapchat")
        }
    }
    
    @IBAction func btnGo(_ sender: Any) {
    }
    
    
    @IBAction func btnDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
