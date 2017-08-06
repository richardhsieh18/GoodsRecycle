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

class LandingViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource
{
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var arrGoods = [Any]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self

        loadData()
        //Animation,Failed
        //animateTable()
    } // viewDidLoad
    
    func loadData()
    {
        
        let urlString = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=8e7d2004-bdcf-45e7-8937-1815f47e6db4"

        Alamofire.request(urlString).responseJSON
            {response in
            guard response.result.isSuccess else
            {
                let error  = response.result.error?.localizedDescription
                print(error!)
                return
            }
            guard let JSON = response.result.value as? [String:Any] else
            {
                print("ERROR")
                return
            }

            if let result = JSON["result"] as? [String:Any]
            {
                if let results = result["results"] as? [Any]
                {
                    self.arrGoods = results
                    self.myCollectionView.reloadData()
                    
                }
            }
        }
        
    }// loadData
    
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrGoods.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LandingCollectionViewCell
        guard let cellData = self.arrGoods[indexPath.row] as? [String:Any] else {
            print("get row \(indexPath.row) error")
            return cell
        }

        
        let placeholderImage = UIImage(named: "nsslsnapchat")
        cell.lblTitle.text = cellData["物品類別"] as? String
        cell.lblLocation.text = cellData["地點"] as? String
        let img_list = cellData["縮圖網址"] as? String
        if let img_url = URL(string: img_list!)
        {
            cell.imgResize.af_setImage(withURL: img_url)
        }else{
            cell.imgResize.image = placeholderImage
        }
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 1
        
        
        return cell
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


}

