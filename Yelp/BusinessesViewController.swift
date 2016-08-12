//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit


class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UISearchControllerDelegate{

    var businesses: [Business]!
    var term: String!

    @IBOutlet weak var tableView: UITableView!

    let searchController = UISearchController(searchResultsController:  nil)

    override func viewDidLoad() {

        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension

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

            for business in businesses {
                print(business.name!)
                print(business.address!)
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
            self.tableView.reloadData()
        }
    }
}

extension BusinessesViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        Business.searchWithTerm("Ho", completion: { (businesses: [Business]!, error: NSError!) -> Void in
        Business.searchWithTerm(searchController.searchBar.text!, completion: { (businesses: [Business]!, error: NSError!) -> Void in

            self.businesses = businesses

            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })

        tableView.reloadData()
    }
}
