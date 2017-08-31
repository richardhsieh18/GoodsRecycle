//
//  DataGood.swift
//  GoodsRecycle
//
//  Created by chang on 2017/8/11.
//  Copyright © 2017年 chang. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

struct Good
{
    let resizeImage:String
    let image:String
    let model:String
    let location:String
    let address:String
    let latitude:String
    let longitude:String
    
    init(json: JSON) {
                self.resizeImage = ("縮圖網址" <~~ json)!
                self.image = ("照片網址" <~~ json)!
                self.model = ("物品類別" <~~ json)!
                self.location = ("地點" <~~ json)!
                self.address = ("地址" <~~ json)!
                self.latitude = ("緯度" <~~ json)!
                self.longitude = ("經度" <~~ json)!
    }
    
//init(resizeImage:String,image:String,model:String,location:String,address:String,latitude:String,longitude:String)
//    {
//        self.resizeImage = resizeImage
//        self.image = image
//        self.model = model
//        self.location = location
//        self.address = address
//        self.latitude = latitude
//        self.longitude = longitude
//    }
}


extension Good{
    static func fetch(completion: @escaping ([Good]) -> Void)
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
                        var dataTransfer :[Good] = []
                        for p in results
                        {
                            
//                            let goodItem = Good.init(resizeImage: p["縮圖網址"] as! String, image: p["照片網址"] as! String, model: p["物品類別"] as! String, location: p["地點"] as! String, address: p["地址"] as! String, latitude: p["緯度"] as! String, longitude: p["經度"] as! String)
//                            let goodItem = Good(
//                                resizeImage: p["縮圖網址"] as! String,
//                                image: p["照片網址"] as! String,
//                                model: p["物品類別"] as! String,
//                                location: p["地點"] as! String,
//                                address: p["地址"] as! String,
//                                latitude: p["緯度"] as! String,
//                                longitude: p["經度"] as! String
//                            )
                            let goodItem = Good(json: p)
                           dataTransfer.append(goodItem)
                        }
                        completion(dataTransfer)
                        print(response.timeline)
                        //self.arrSearch = self.arrGoods
                        //self.myCollectionView.reloadData()
                    }
                }
        }
        
    }// fetchData
}
