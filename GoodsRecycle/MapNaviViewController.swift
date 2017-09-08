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

class MapNaviViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var naviMap: MKMapView!

    var myLocation: CLLocationManager!
    var selectedSiteLat: Double!
    var selectedSiteLon: Double!
    var selectedTitle: String!
    var selectedSubtitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviMap.delegate = self
        myLocation = CLLocationManager()
        myLocation.requestWhenInUseAuthorization()

        let coordinate = CLLocationCoordinate2DMake(selectedSiteLat, selectedSiteLon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = selectedTitle
        annotation.subtitle = selectedSubtitle
        let latDelta: CLLocationDegrees = 0.01
        let lonDelta: CLLocationDegrees = 0.01
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        if coordinate != nil {
            let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: span)
            naviMap.setRegion(region, animated: true)
        }
        
        //add NaviBtn
        
        
        
        
        naviMap.addAnnotation(annotation)
        //Show Callout面板
        naviMap.selectAnnotation(annotation, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Pin"
        var result = naviMap.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if result == nil {
            result = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            result?.annotation = annotation
        }
        result?.canShowCallout = true
        
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        leftButton.setImage(UIImage(named: "navigation.png"), for: .normal)
        leftButton.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        result?.leftCalloutAccessoryView = leftButton
        
        return result
    }
    
    func btnTapped() {
        let coordinate = CLLocationCoordinate2DMake(selectedSiteLat, selectedSiteLon)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        MKMapItem.openMaps(with: [mapItem], launchOptions: options)
    }
    

}
