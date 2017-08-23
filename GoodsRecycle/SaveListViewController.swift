//
//  SaveListViewController.swift
//  GoodsRecycle
//
//  Created by chang on 2017/8/23.
//  Copyright © 2017年 chang. All rights reserved.
//

import UIKit
import CoreData

class SaveListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var saveTableView: UITableView!
    

    var saveArr = [[String:Any?]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveTableView.delegate = self
        saveTableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.retriveInfo()
        saveTableView.reloadData()
        if saveArr.isEmpty == false {
        //讓Scroll回到最上面
        saveTableView.scrollToRow(at: [0,0], at: .top, animated: true)
        }
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
            saveArr.remove(at: indexPath.row)
            self.deleteCoreDataRow()
            self.saveTableView.reloadData()
        }
    }
    func deleteCoreDataRow(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let batch = NSBatchDeleteRequest(fetchRequest: SaveLists.fetchRequest())
        do {
            try appDelegate.persistentContainer.persistentStoreCoordinator.execute(batch, with: context)
        }catch{
            print(error)
        }
    }
    
    func retriveInfo(){
        self.saveArr.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        print(context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SaveLists")
        let sort = NSSortDescriptor(key: "savetime", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(fetchRequest)
            print(results)
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
