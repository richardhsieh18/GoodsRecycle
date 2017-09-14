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
    
    let segueNavi:String = "startNavi"
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == self.segueNavi {
        let vc = segue.destination as! MapNaviViewController
        let btn = sender as! UIButton
        switch btn.tag {
        case 100:
            vc.selectedSiteLat = 25.066028
            vc.selectedSiteLon = 121.584503
            vc.selectedTitle = "內湖展示場"
            vc.selectedSubtitle = "臺北市內湖區行忠路178巷1號"
        case 101:
            vc.selectedSiteLat = 25.03718
            vc.selectedSiteLon = 121.49546
            vc.selectedTitle = "萬華展示場"
            vc.selectedSubtitle = "臺北市萬華區環河南路2段133號"
        default:
            print("nothing")
        }
        }
    }
    
    @IBAction func navigationStart(_ sender: UIButton) {
        //sender也一併傳送過去
        performSegue(withIdentifier: segueNavi, sender: sender)
    }
    
}
