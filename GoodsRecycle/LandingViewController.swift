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


struct Good
{
    var resizeImage:String
    var image:String
    var model:String
    var location:String
    var address:String
    var latitude:String
    var longitude:String
}

class LandingViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate
{
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var barSearch: UISearchBar!
    
    var arrGoods = [Good]()
    var arrSearch = [Good]()
    var searchBarActive:Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        barSearch.delegate = self
        //允許CollectionView選取
        myCollectionView.allowsSelection = true

        loadData()
        
        //dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    } // viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
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
                if let results = result["results"] as? [[String:Any]]
                {
                    for p in results
                    {
                        let goodItem = Good.init(resizeImage: p["縮圖網址"] as! String, image: p["照片網址"] as! String, model: p["物品類別"] as! String, location: p["地點"] as! String, address: p["地址"] as! String, latitude: p["緯度"] as! String, longitude: p["經度"] as! String)
                        self.arrGoods.append(goodItem)
                    }
                    self.arrSearch = self.arrGoods
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
        if self.searchBarActive
        {
            return arrSearch.count
        }
            return arrGoods.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LandingCollectionViewCell
        
//        cell.transform = CGAffineTransform(scaleX: 1.1 , y: 1.1)
//        //Damping是彈跳數，越接近0，彈跳數越大
//        //Velocity是動畫的初始速度，越接近0越平滑
//        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0 , options: .curveEaseInOut, animations: {
//            cell.transform = CGAffineTransform(scaleX: 0.98 , y: 0.98)
//        }) { (animated) in
//            cell.transform = CGAffineTransform.identity
//        }
        
//        guard let cellData = self.arrGoods[indexPath.row] as? [String:Any] else {
//            print("get row \(indexPath.row) error")
//            return cell
//        }
        let placeholderImage = UIImage(named: "nsslsnapchat")

        if self.searchBarActive
        {
            let cellData = self.arrSearch[indexPath.row]
            cell.lblTitle.text = cellData.model //cellData["物品類別"] as? String
            cell.lblLocation.text = cellData.location //cellData["地點"] as? String
            let img_list = cellData.resizeImage //cellData["縮圖網址"] as? String
            if let img_url = URL(string: img_list)
            {
                cell.imgResize.af_setImage(withURL: img_url)
            }else{
                cell.imgResize.image = placeholderImage
            }
        }else{
        let cellData = arrGoods[indexPath.row]
        cell.lblTitle.text = cellData.model //cellData["物品類別"] as? String
        cell.lblLocation.text = cellData.location //cellData["地點"] as? String
        let img_list = cellData.resizeImage //cellData["縮圖網址"] as? String
        if let img_url = URL(string: img_list)
        {
            cell.imgResize.af_setImage(withURL: img_url)
        }else{
            cell.imgResize.image = placeholderImage
        }
        
        }
        
        
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 1
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
            vc.cellData = self.searchBarActive ? arrSearch[(selectItemRows?[0].row)!] : arrGoods[(selectItemRows?[0].row)!]
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.global(qos: .userInteractive).async {
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
            self.arrSearch = self.arrGoods.filter{$0.model.contains(searchText)}
            self.searchBarActive = true
        DispatchQueue.main.async {
                self.updateData()
        }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.barSearch.text = ""
        self.arrSearch = self.arrGoods
        barSearch.resignFirstResponder()
        self.updateData()
    }
    
    func updateData()
    {
        self.myCollectionView.reloadData()
    }
    
    //MARK: dismiss Keyboard
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}

