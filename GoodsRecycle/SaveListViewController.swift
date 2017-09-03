//
//  SaveListViewController.swift
//  GoodsRecycle
//
//  Created by chang on 2017/8/23.
//  Copyright © 2017年 chang. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class SaveListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GADBannerViewDelegate {
    
    @IBOutlet weak var saveTableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!

    var saveArr = [[String:Any?]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveTableView.delegate = self
        saveTableView.dataSource = self
        
        bannerView.adUnitID = "ca-app-pub-7776511214644166/4396773498"
        bannerView.rootViewController = self
        bannerView.delegate = self
        //要加這行才廣告才會出來
        bannerView.load(GADRequest())
    }
    override func viewWillAppear(_ animated: Bool) {
        self.retriveInfo()
        saveTableView.reloadData()
        if saveArr.isEmpty == false {
        //讓Scroll回到最上面
        saveTableView.scrollToRow(at: [0,0], at: .top, animated: true)
        }
        //當點擊進來的時候將badgeValue設為nil
        self.tabBarController?.tabBar.items?[1].badgeValue = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(saveArr.count)
        return saveArr.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SaveListTableViewCell
            let imgData =  saveArr[indexPath.row]["image"] as? Data
            cell.imgSave.image = UIImage(data: imgData!)
            cell.lblModel.text = saveArr[indexPath.row]["model"] as? String
            cell.lblTime.text = saveArr[indexPath.row]["savetime"] as? String
            cell.lblLocation.text = saveArr[indexPath.row]["location"] as? String
            return cell
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteCoreDataRow(indexPath)
            saveArr.remove(at: indexPath.row)
            self.saveTableView.deleteRows(at: [indexPath], with: .fade)
            //self.saveTableView.reloadData()
        }
    }
    //刪除coreData裡個別資料
    func deleteCoreDataRow(_ indexPath: IndexPath){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SaveLists")
        let sort = NSSortDescriptor(key: "savetime", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.returnsObjectsAsFaults = false
        let results = try? context.fetch(fetchRequest)
        context.delete(results?[indexPath.row] as! NSManagedObject)
        do { try context.save() } catch { print(error) }
    }

    
//這個功能看來是全刪
//    func deleteCoreData(){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let batch = NSBatchDeleteRequest(fetchRequest: SaveLists.fetchRequest())
//        do {
//            try appDelegate.persistentContainer.persistentStoreCoordinator.execute(batch, with: context)
//        }catch{
//            print(error)
//        }
//    }
    
    
    func retriveInfo(){
        self.saveArr.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //print(context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SaveLists")
        let sort = NSSortDescriptor(key: "savetime", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(fetchRequest)
            //print(results)
            if results.count > 0 {
                var arrResult = [String:Any]()
                for result in results as! [NSManagedObject]{
                    if let model = result.value(forKey: "model") as? String {
                        arrResult["model"] = model
                    }
                    if let location = result.value(forKey: "location") as? String {
                        arrResult["location"] = location
                    }
                    if let time = result.value(forKey: "savetime") as? String {
                        arrResult["savetime"] = time
                    }
                    if let image = result.value(forKey: "image") as? Data {
                        arrResult["image"] = image
                    }
                    saveArr.append(arrResult)
                }
            }
        }catch{
            print(error)
        }
    }

}

//Add banner
extension SaveListViewController{
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
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
