//
//  SitesViewController.swift
//  GoodsRecycle
//
//  Created by chang on 2017/9/5.
//  Copyright © 2017年 chang. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SitesViewController: UIViewController,GADBannerViewDelegate {

    @IBOutlet weak var neiView: UIView!
    @IBOutlet weak var wanView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        neiView.layer.cornerRadius = 8
        wanView.layer.cornerRadius = 8
        neiView.clipsToBounds = true
        wanView.clipsToBounds = true
        
        let leftTransform = CGAffineTransform.init(translationX: -1000, y: 0)
        let rightTransform = CGAffineTransform.init(translationX: +1000, y: 0)
        neiView.transform = leftTransform
        wanView.transform = rightTransform
        
        //Add banner
        //bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.adUnitID = "ca-app-pub-7776511214644166/4396773498"
        bannerView.rootViewController = self
        bannerView.delegate = self
        //要加這行才廣告才會出來
        bannerView.load(GADRequest())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.5) {
            self.neiView.transform = CGAffineTransform.identity
            self.wanView.transform = CGAffineTransform.identity
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
