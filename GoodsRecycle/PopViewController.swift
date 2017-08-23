//
//  PopViewController.swift
//  GoodsRecycle
//
//  Created by chang on 2017/8/9.
//  Copyright © 2017年 chang. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreData

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
        self.imgPop.layer.cornerRadius = 10
        self.imgPop.clipsToBounds = true
        //queryGoodData()
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
    
    //MARK: CoreData
    @IBAction func btnGo(_ sender: Any) {
        print(NSPersistentContainer.defaultDirectoryURL())
        insertGoodData()
        self.btnDismiss(self)
    }
    
    func insertGoodData(){
        //CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let good = NSEntityDescription.insertNewObject(forEntityName: "SaveLists", into: context)
        good.setValue(cellData.model, forKey: "model")
        good.setValue(cellData.location, forKey: "location")
        good.setValue(cellData.address, forKey: "address")
        good.setValue(cellData.latitude, forKey: "latitude")
        good.setValue(cellData.longitude, forKey: "longitude")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd H:mm:ss"
        let dateString = formatter.string(from: Date())
        good.setValue(dateString, forKey: "savetime")
        //guard let img_url = URL(string: cellData.image) else{ return }
        //let imagedata = try? Data(contentsOf: img_url)
        //let image = UIImage(data: imagedata!)
        //let data = UIImageJPEGRepresentation(image!, 0.5)
        let data = UIImageJPEGRepresentation(imgPop.image!, 0.5)
        good.setValue(data, forKey: "image")
               //存檔用do catch
        DispatchQueue.global(qos:.userInitiated).async {
            do {
                try context.save()
                print("儲存成功")
            }catch{
                print("error")
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"圖片已儲存"), object: nil)
    }
    
    
    @IBAction func btnDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
