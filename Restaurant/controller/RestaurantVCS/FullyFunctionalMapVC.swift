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
        mp.showsUserLocation = true
        mp.isUserInteractionEnabled = true
        return mp
    }()
    lazy var closeButton:UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), for: .normal)
        bt.constrainHeight(constant: 34)
        bt.constrainWidth(constant: 34)
        bt.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return bt
    }()
    lazy var directionButton:UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "direction").withRenderingMode(.alwaysOriginal), for: .normal)
        bt.constrainHeight(constant: 34)
        bt.constrainWidth(constant: 34)
        bt.addTarget(self, action: #selector(handleDirection), for: .touchUpInside)
        return bt
    }()
    lazy var segementedController:UISegmentedControl = {
        let items = ["Car", "Walking"]
        let sg = UISegmentedControl(items: items)
        sg.addTarget(self, action: #selector(handleChosen), for: .valueChanged)
        sg.constrainHeight(constant: 30)
        sg.constrainWidth(constant: 120)
        sg.isHide(true)
        sg.selectedSegmentIndex = 0
        return sg
    }()
    let locationManager = CLLocationManager()
    var currentPlacemark : CLPlacemark?
    var directionTransportType = MKDirectionsTransportType.automobile
    var currentRoute : MKRoute?
    
    
    fileprivate let gecoder = CLGeocoder()
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
        loadMapUsingGecoder()
        setupLocationManager()
    }
    
    //MARK: -user methods
    
    func setupLocationManager()  {
        locationManager.delegate = self
         locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        
//        locationManager.startUpdatingLocation()
       
    }
    
    fileprivate  func loadMapUsingGecoder()  {
        
        gecoder.geocodeAddressString(restaurant.location ?? "") { (placemarks, err) in
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                self.currentPlacemark = placemark
                
                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // Display the annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
        
    }
    
    fileprivate  func setupViews()  {
        view.addSubViews(views: mapView,closeButton,directionButton,segementedController)
        
        
        mapView.fillSuperview()
    closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 40, left: 0, bottom: 0, right: 16))
        directionButton.anchor(top: closeButton.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 8, left: 0, bottom: 0, right: 16))
        segementedController.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 16, right: 16))
    }
    
   @objc func handleClose()  {
        dismiss(animated: true)
    }
    
   @objc func handleDirection()  {
    segementedController.isHide(false)
    guard let currentPlacemark = currentPlacemark else {print("no       "); return  }
    let directRequest =  MKDirections.Request()
    
    directRequest.source = MKMapItem.forCurrentLocation()
    let destPlacemark = MKPlacemark(placemark: currentPlacemark)
    directRequest.destination = MKMapItem(placemark: destPlacemark)
    directRequest.transportType = self.directionTransportType
    
    //calculate directions
    let driections = MKDirections(request: directRequest)
    driections.calculate { (res, err) in
        guard let res = res else {if let err = err {print("error    ",err.localizedDescription)};return}
        let route = res.routes[0]
        self.currentRoute = route
         self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
       
        //for scale the screen size
        
        let rect = route.polyline.boundingMapRect
        self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
    }
    
    
    }
    
   @objc func handleChosen(sender: UISegmentedControl)  {
    switch sender.selectedSegmentIndex {
    case 0:
        directionTransportType = .automobile
    case 1:
        directionTransportType = .walking
    default:
        break
    }
    sender.isHide(false)
    }
}

//MARK: -extensions

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
        leftIcon.isUserInteractionEnabled = true
        leftIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTappped)))
        annotaionView?.leftCalloutAccessoryView = leftIcon
        annotaionView?.tintColor = UIColor.orange
        
        return annotaionView
    }
    
    @objc func handleTappped()  {
        print(54545)
        guard let routes = self.currentRoute?.steps else { return  }
        let route = RoutableDirectionVC(routes:routes )
        let nav = UINavigationController(rootViewController: route)
        present(nav, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        print(54545)
//        guard let routes = self.currentRoute?.steps else { return  }
//        let route = RoutableDirectionVC(routes:routes )
//        let nav = UINavigationController(rootViewController: route)
//        present(nav, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
       
        renderer.strokeColor = (directionTransportType == .automobile) ? UIColor.blue : .orange
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
}

extension FullyFunctionalMapVC : CLLocationManagerDelegate {
    
    
}
