//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UISearchControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate{

    var businesses: [Business]!
    var term: String!

    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var viewType: UIBarButtonItem!

    @IBOutlet weak var tableView: UITableView!

    let searchController = UISearchController(searchResultsController:  nil)

    var locationManager : CLLocationManager!

    override func viewDidLoad() {

        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        mapView.delegate = self

        // Scroll bar height
        tableView.estimatedRowHeight = 120 // This is used in conjunction with UITableViewAutomaticDimension

        /*
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
        
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        */


        /* Example of Yelp search with more search options specified */
        // Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: nil)
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: nil, deals: nil, distance: 40000)
        {
            (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
        
            // Important
            self.tableView.reloadData()

            self.mapView.removeAnnotations(self.mapView.annotations)

            for business in businesses {
                print(business.name!)
                print(business.address!)


                var coordinate2D = CLLocationCoordinate2D()
                coordinate2D.latitude = business.coordinate!["latitude"] as! Double
                coordinate2D.longitude = business.coordinate!["longitude"] as! Double

                self.addAnnotationAtCoordinate(coordinate2D, name: business.name!, categories: business.categories!)
            }
        }

        // Search bar in the title
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self

        self.searchController.hidesNavigationBarDuringPresentation = false
//        self.searchController.dimsBackgroundDuringPresentation = true

        tableView.dataSource = self
        tableView.delegate = self

        self.navigationItem.titleView = searchController.searchBar

        self.definesPresentationContext = true
        
        self.setupSearchBar()

        // Map
        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
        mapView.hidden = true
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(centerLocation)

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()

        // draw circular overlay centered in San Francisco
        let coordinate = CLLocationCoordinate2D(latitude: 37.7833, longitude: -122.4167)
        let circleOverlay: MKCircle = MKCircle(centerCoordinate: coordinate, radius: 1000)
        mapView.addOverlay(circleOverlay)

    }

    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }

    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, name: String, categories: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        annotation.subtitle = categories
        mapView.addAnnotation(annotation)
    }

//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = "customAnnotationView"
//
//        // custom image annotation
//        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
//        if (annotationView == nil) {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//        }
//        else {
//            annotationView!.annotation = annotation
//        }
//        annotationView!.image = UIImage(named: "customAnnotationImage")
//        
//        return annotationView
//    }

//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = "customAnnotationView"
//        // custom pin annotation
//        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
//        if (annotationView == nil) {
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//        }
//        else {
//            annotationView!.annotation = annotation
//        }
//        if #available(iOS 9.0, *) {
//            annotationView!.pinTintColor = UIColor.greenColor()
//        } else {
//            // Fallback on earlier versions
//        }
//        
//        return annotationView
//    }

    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circleView = MKCircleRenderer(overlay: overlay)
        circleView.strokeColor = UIColor.redColor()
        circleView.lineWidth = 1
        return circleView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell

        cell.business = businesses[indexPath.row]
        
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil{
            return businesses!.count
        }else{
            return 0
        }
    }

    func setupSearchBar(){

    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController // A chance to set itself as the delegate for the next transition view controller
        filtersViewController.delegate = self
    }

    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {

        let cuisines = filters["cuisine"] as? [String]
        let distanceFilter = DistanceFilter()
        print(filters["sortOption"])
        let sort = filters["sortOption"] as! Int
        let sortMode = YelpSortMode(rawValue: sort)
        let deal = filters["deal"] as? Bool
        let distance = distanceFilter.distanceCategories[filters["distanceIdx"] as! Int]["value"] as! Float
        print(distance)

        Business.searchWithTerm("Restaurants", sort: sortMode, categories: cuisines, deals: deal, distance: distance) { (businesses: [Business]!, error: NSError!) in
            self.businesses = businesses

            self.mapView.removeAnnotations(self.mapView.annotations)

            for business in self.businesses {
                print(business.name!)
                print(business.address!)
                for business in businesses {
                    print(business.name!)
                    print(business.address!)

                    var coordinate2D = CLLocationCoordinate2D()
                    coordinate2D.latitude = business.coordinate!["latitude"] as! Double
                    coordinate2D.longitude = business.coordinate!["longitude"] as! Double

                    self.addAnnotationAtCoordinate(coordinate2D, name: business.name!, categories: business.categories!)
                }
            }

            self.tableView.reloadData()
        }
    }


    @IBAction func onTap(sender: UIBarButtonItem) {
        if(viewType.title == "Map"){
            mapView.hidden = false
            tableView.hidden = true
            viewType.title = "List"
        }else{
            mapView.hidden = true
            tableView.hidden = false
            viewType.title = "Map"
        }

//        viewType.width = 20.0

    }


}

extension BusinessesViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        Business.searchWithTerm("Ho", completion: { (businesses: [Business]!, error: NSError!) -> Void in
        Business.searchWithTerm(searchController.searchBar.text!, completion: { (businesses: [Business]!, error: NSError!) -> Void in

            self.businesses = businesses

            self.mapView.removeAnnotations(self.mapView.annotations)

            for business in businesses {
                print(business.name!)
                print(business.address!)

                var coordinate2D = CLLocationCoordinate2D()
                coordinate2D.latitude = business.coordinate!["latitude"] as! Double
                coordinate2D.longitude = business.coordinate!["longitude"] as! Double

                self.addAnnotationAtCoordinate(coordinate2D, name: business.name!, categories: business.categories!)
            }
        })


        tableView.reloadData()
    }
}
