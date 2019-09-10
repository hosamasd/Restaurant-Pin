//
//  FullyFunctionalMapVC.swift
//  Restaurant
//
//  Created by hosam on 9/9/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import MapKit

class FullyFunctionalMapVC: UIViewController {
    lazy var mapView:MKMapView = {
        let mp = MKMapView()
        mp.delegate = self
        mp.showsCompass = true
        mp.showsScale = true
        mp.showsTraffic = true
        return mp
    }()
    let restaurant:Restaurant
    init(rest:Restaurant){
        self.restaurant = rest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    
    func loadData()  {
        
            let gecoder = CLGeocoder()
        
            
        gecoder.geocodeAddressString(restaurant.location ?? "") { (placemarks, err) in
                guard  let place = placemarks?.first?.location else {return}
                
                 let annotation = MKPointAnnotation()
                annotation.coordinate = place.coordinate
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                self.mapView.showAnnotations([annotation], animated: true)
                self.mapView.selectAnnotation(annotation, animated: true)
//                let region = MKCoordinateRegion(center: place.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
//                self.mapView.setRegion(region, animated: true)
            }
        
    }
    
    func setupViews()  {
        view.addSubViews(views: mapView)
        
        mapView.fillSuperview()
    }
}

extension FullyFunctionalMapVC: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifer = "myPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        var annotaionView = mapView.dequeueReusableAnnotationView(withIdentifier: identifer)
        if annotaionView == nil {
            annotaionView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifer)
            annotaionView?.canShowCallout = true
        }
        
        let leftIcon = UIImageView(frame: .init(x: 0, y: 0, width: 53, height: 53))
        leftIcon.image = UIImage(data: restaurant.image ?? Data())
        annotaionView?.leftCalloutAccessoryView = leftIcon
        annotaionView?.tintColor = UIColor.orange
//        annotaionView.pinTintColor = .blue
        
        return annotaionView
    }
    
}
