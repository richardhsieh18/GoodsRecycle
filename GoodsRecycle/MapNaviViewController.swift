//
//  MapNaviViewController.swift
//  GoodsRecycle
//
//  Created by chang on 2017/9/8.
//  Copyright © 2017年 chang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapNaviViewController: UIViewController {

    @IBOutlet weak var naviMap: MKMapView!
    
    var myLocation: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLocation = CLLocationManager()
        myLocation.requestWhenInUseAuthorization()
        
        let coordinate = myLocation.location?.coordinate
        let latDelta: CLLocationDegrees = 0.01
        let lonDelta: CLLocationDegrees = 0.01
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        if coordinate != nil {
            let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinate!, span: span)
            
            naviMap.setRegion(region, animated: true)
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
