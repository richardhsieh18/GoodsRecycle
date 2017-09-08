//
//  ViewController.swift
//  GoodsRecycle
//
//  Created by chang on 2017/8/4.
//  Copyright © 2017年 chang. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import AVFoundation
import GoogleMobileAds


class LandingViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,GADBannerViewDelegate
{
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var barSearch: UISearchBar!
    @IBOutlet weak var bannerView: GADBannerView!

    
    var arrGoods = [Good]()
    var arrSearch = [Good]()
    var searchBarActive:Bool = false
    let refresh: UIRefreshControl = UIRefreshControl()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let layout = myCollectionView.collectionViewLayout as? WaterfallViewLayout
        {
            layout.delegate = self
        }
        
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        barSearch.delegate = self
        barSearch.scopeButtonTitles = ["內湖","萬華",]
        //barSearch.tintColor = UIColor.white
        //barSearch.barTintColor = UIColor(red: 67/255, green: 216/255, blue: 102/255, alpha: 1)
        //barSearch.sizeToFit()
        //允許CollectionView選取
        self.collectionAllowSelected()

        //將fetch拉成func
        self.fetchData()
        
        //Add banner
        //bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.adUnitID = "ca-app-pub-7776511214644166/4396773498"
        bannerView.rootViewController = self
        bannerView.delegate = self
        //要加這行才廣告才會出來
        bannerView.load(GADRequest())
        
        //加上refreschControl
        refresh.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        myCollectionView.addSubview(refresh)
        
    } // viewDidLoad
    
    //override func viewWillAppear(_ animated: Bool) {    }
    
    //使用collectionviewheader需要用這個delegate method
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
//    {
//        switch kind
//        {
//        case UICollectionElementKindSectionHeader:
//            let headerview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
//            return headerview
//        default:
//            assert(false,"Error")
//        }
//    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.searchBarActive
        {
            return arrSearch.count
        }
            return arrGoods.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LandingCollectionViewCell
        
        cell.transform = CGAffineTransform(scaleX: 1.1 , y: 1.1)
        //Damping是彈跳數，越接近0，彈跳數越大
        //Velocity是動畫的初始速度，越接近0越平滑
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0 , options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.98 , y: 0.98)
        }) { (animated) in
            cell.transform = CGAffineTransform.identity
        }
        
//        guard let cellData = self.arrGoods[indexPath.row] as? [String:Any] else {
//            print("get row \(indexPath.row) error")
//            return cell
//        }
        let placeholderImage = UIImage(named: "nsslsnapchat")
        let cellData:Good
        if self.searchBarActive
        {
            cellData = self.arrSearch[indexPath.row]
        }else{
            cellData = self.arrGoods[indexPath.row]
        }
        cell.lblTitle.text = cellData.model //cellData["物品類別"] as? String
        cell.lblLocation.text = cellData.location //cellData["地點"] as? String
        let img_list = cellData.image //cellData["縮圖網址"] as? String
        if let img_url = URL(string: img_list)
        {
            cell.imgResize.af_setImage(withURL: img_url)
        }else{
            cell.imgResize.image = placeholderImage
        }
        
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        //cell.layer.borderColor = UIColor.orange.cgColor
        //cell.layer.borderWidth = 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("123")
        performSegue(withIdentifier: "pop", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pop"  {
            let vc = segue.destination as! PopViewController
            let selectItemRows = myCollectionView.indexPathsForSelectedItems
            print(selectItemRows!)
            vc.cellData = self.searchBarActive ? arrSearch[(selectItemRows?[0].item)!] : arrGoods[(selectItemRows?[0].item)!]
        }
    }
    
    
    //Animation
//    func animateTable()
//    {
//        myCollectionView.reloadData()
//        let cells = myCollectionView.visibleCells
//        let tableHeight: CGFloat = myCollectionView.bounds.size.height
//        for i in cells
//        {
//            let cell: UICollectionViewCell = i as UICollectionViewCell
//            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
//        }
//        var index = 0
//        for a in cells {
//            let cell: UICollectionViewCell = a as UICollectionViewCell
//            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .transitionFlipFromBottom, animations:
//                {
//                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
//                }, completion: nil)
//            index += 1
//        }
//    }

    
    //MARK: searchBar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        myCollectionView.allowsSelection = false
        self.hideKeyboardWhenTappedAround()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //將可選取改為false，tap關鍵盤才不會切到下一頁
        myCollectionView.allowsSelection = false
        DispatchQueue.global(qos: .userInteractive).async
            {
                if searchText == ""
                {
                    self.arrSearch = self.arrGoods
                    DispatchQueue.main.async
                    {
                        self.updateData()
                    }
                    self.searchBarActive = false
                    return
                }
                self.arrSearch = self.arrSearch.filter{$0.model.contains(searchText)}
                self.searchBarActive = true
                    DispatchQueue.main.async {
                        self.updateData()
                    }
            }
        self.hideKeyboardWhenTappedAround()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.barSearch.text = ""
        self.arrSearch = self.arrGoods
        barSearch.resignFirstResponder()
        self.updateData()
        self.collectionAllowSelected()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.hideKeyboardWhenTappedAround()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dismissKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 1:
            searchBar.text = ""
            searchBarActive = true
            self.arrSearch = self.arrGoods.filter{$0.location.contains("萬華")}
        default :
            searchBar.text = ""
            searchBarActive = true
            self.arrSearch = self.arrGoods.filter{$0.location.contains("內湖")}
        }
            updateData()
    }
    
    func fetchData() {
        //重構後的Data  170814
        Good.fetch { (dataTransfer) in
            self.arrGoods = dataTransfer
            self.arrSearch = dataTransfer
            self.updateData()
            //170909 加上refresh功能需補上end才會停止，並且將scopebutton的index改回0
            self.barSearch.selectedScopeButtonIndex = 0
            self.refresh.endRefreshing()
        }
        
    }
    
    func updateData()
    {
        self.myCollectionView.collectionViewLayout.invalidateLayout()
        self.myCollectionView.reloadData()
        self.myCollectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    fileprivate func collectionAllowSelected(){
        myCollectionView.allowsSelection = true
    }

// 更新collectionViewlayout 的func
//    private func updateCollectionViewLayout(with size: CGSize)
//    {
//        if let layout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
//        {
//            layout.itemSize = CGSize(width: 200, height: Int(arc4random_uniform(100) + 100))
//            layout.invalidateLayout()
//        }
//    }
    
}
//Add banner
extension LandingViewController{
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        view.addSubview(bannerView)
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}

extension LandingViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        //允許選取在main serial裡
        DispatchQueue.main.async {
            self.collectionAllowSelected()
        }
    }
}

//collectionView裡的content
extension LandingViewController : WaterfallLayoutDelegate
{
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
//        let photoStr = arrGoods[indexPath.item].resizeImage
//        let photoUrl = URL(string: photoStr)
//        let photoData = try? Data(contentsOf: photoUrl!)
//        let photo = UIImage(data: photoData!)
//        let boundingRect = CGRect(x: 0, y: 0, width: withWidth, height: CGFloat(MAXFLOAT))
//        let rect = AVMakeRect(aspectRatio: (photo?.size)! , insideRect: boundingRect)
//        return rect.height
        return CGFloat(arc4random_uniform(3) * 30 + 180)
    }
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
//        let annotationPadding = CGFloat(4)
//        let annotationHeaderHeight = CGFloat(17)
//        let photoStr = arrGoods[indexPath.item].resizeImage
//        let photoUrl = URL(string: photoStr)
//        let photoData = try? Data(contentsOf: photoUrl!)
//        let photo = UIImage(data: photoData!)
//        let font = UIFont(name: "AvenirNext-Regular", size: 10)!
//        let height = annotationPadding + annotationHeaderHeight + annotationPadding
//        return height
        return 60
    }

}

