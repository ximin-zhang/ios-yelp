//
//  FiltersViewController.swift
//  Yelp
//
//  Created by ximin_zhang on 8/9/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import SwiftForms

enum FilterRowIdentifier : String {
    case Deals = "Offer a deal"
    case Distance = "Distance"
    case Sort = "Sort by"
    case Category = "Category"
}

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject]) // like interface, protocol methods may not have bodies
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, CuisineCategoryCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?

    var currentDistanceFilter: DistanceFilter!
    var currentSortOptions: SortOptions!
    var currentCuisineFilters: CuisineFilters!

    var isOfferDeal: Bool! // Initialization of an empty dictionary
    var distanceIdx: Int = 0
    var sortOptionIdx: Int = 0
    var cuisineSwitchStates = [Int: Bool]()

    // Collapse status
    var distanceCellCollapse: Bool = false
    var sortCellCollapse: Bool = false
    var cuisineCategoryCollapse: Bool = true

    var sortTransition: Bool = true
    var distanceTransition: Bool = true

    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

        var filters = [String : AnyObject]()
        var selectedCuisines = [String]()

        filters["deal"] = isOfferDeal

        filters["distanceIdx"] = distanceIdx

        filters["sortOption"] = sortOptionIdx
        print(sortOptionIdx)

        for(row, isSelected) in cuisineSwitchStates {
            if isSelected{
                selectedCuisines.append(currentCuisineFilters.cuisineCategories[row]["code"]! )
            }
        }

        if selectedCuisines.count > 0{
            filters["cuisine"] = selectedCuisines
        }

        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // categories = yelpCategories()

        // should be set by the class that instantiates this view controller
        currentDistanceFilter = currentDistanceFilter ?? DistanceFilter()
        currentSortOptions = currentSortOptions ?? SortOptions()
        currentCuisineFilters = currentCuisineFilters ?? CuisineFilters()

        //

        tableView.dataSource = self
        tableView.delegate = self

        let cuisineCount = currentCuisineFilters.cuisineCategories.count

        if (cuisineSwitchStates.count == 0) {
            for row in 0 ... (cuisineCount - 1) {
                cuisineSwitchStates[row] = false
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
////        let indexPath = tableView.indexPathForCell(switchCell)!
//        self.isOfferDeal = value
//    }

    func distanceCell(distanceCell: DistanceCell){
        let indexPath = tableView.indexPathForCell(distanceCell)!
        self.distanceIdx = indexPath.row
        print(self.distanceIdx)
    }

    func sortOptionCell(sortOptionCell: SortOptionCell){
        let indexPath = tableView.indexPathForCell(sortOptionCell)!
        self.sortOptionIdx = indexPath.row
        print(self.sortOptionIdx)
    }

    func cuisineSwitchCell(cuisineCategoryCell: CuisineCategoryCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(cuisineCategoryCell)!
        self.cuisineSwitchStates[indexPath.row] = value
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //  return tableStructure.count
        return 4
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return " "
        }
        else if(section == 1){
            return "Distance"
        }
        else if(section == 2){
            return "Sort By"
        }
        else{
            return "Category"
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(section == 0){
            return 1
        }else if(section == 1){
            if(distanceCellCollapse == false){
                return currentDistanceFilter.distanceCategories.count
            }else{
                return 1
            }

        }else if(section == 2){
            if(sortCellCollapse == false){
                return currentSortOptions.sortOptions.count
            }else{
                return 1
            }
        }else{
            if(cuisineCategoryCollapse == true){
                return 4
            }else{
                return currentCuisineFilters.cuisineCategories.count
            }

        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.switchLabel.text = "Offer a deal"
            return cell
        }else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("DistanceCell", forIndexPath: indexPath) as! DistanceCell
            if(indexPath.row == self.distanceIdx){
                cell.onSelect.image = UIImage(named: "CheckedIcon")
            }else{
                cell.onSelect.image = UIImage(named: "CircleIcon")
            }
            if(distanceCellCollapse == true){
                cell.distanceLabel.text = currentDistanceFilter.distanceCategories[distanceIdx]["category"] as? String
                cell.onSelect.image = UIImage(named: "DownArrow")
            }else{
                cell.distanceLabel.text = currentDistanceFilter.distanceCategories[indexPath.row]["category"] as? String
            }

            return cell
        }else if(indexPath.section == 2){
            let cell = tableView.dequeueReusableCellWithIdentifier("SortOptionCell", forIndexPath: indexPath) as! SortOptionCell
            if(indexPath.row == self.sortOptionIdx){
                cell.onSelect.image = UIImage(named: "CheckedIcon")
            }else{
                cell.onSelect.image = UIImage(named: "CircleIcon")
            }

            if(sortCellCollapse == true){
                cell.sortOptionLabel.text = currentSortOptions.sortOptions[sortOptionIdx]["option"] as? String
                cell.onSelect.image = UIImage(named: "DownArrow")
            }else{
                cell.sortOptionLabel.text = currentSortOptions.sortOptions[indexPath.row]["option"] as? String
            }

            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("CuisineCategoryCell", forIndexPath: indexPath) as! CuisineCategoryCell

            if(cuisineCategoryCollapse == true){
                if(indexPath.row <= 2){
                    cell.categoryLabel.text = currentCuisineFilters.cuisineCategories[indexPath.row]["name"]! as String
                }
                if(indexPath.row == 3){
                    cell.categoryLabel.text = "See All"
//                    let labelWidth = cell.categoryLabel.frame.width
//                    let cellWidth = cell.frame.width
                    cell.switchControl.hidden = true
                    cell.categoryLabel.textAlignment = .Center
                }
            }else{
                cell.categoryLabel.textAlignment = .Left
                cell.switchControl.hidden = false
                cell.categoryLabel.text = currentCuisineFilters.cuisineCategories[indexPath.row]["name"]! as String
            }

            cell.switchControl.on = cuisineSwitchStates[indexPath.row] ?? false

            cell.delegate = self

            return cell
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if(indexPath.section == 0){

        }

        if(indexPath.section == 1){

            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = NSIndexSet(indexesInRange: range)

            distanceCellCollapse = !distanceCellCollapse

            if(distanceCellCollapse == true){
                self.distanceIdx = indexPath.row
            }

            self.tableView.reloadSections(sectionToReload, withRowAnimation: .Fade)

        }

        if(indexPath.section == 2){

            let range = NSMakeRange(indexPath.section, 2)
            let sectionToReload = NSIndexSet(indexesInRange: range)

            sortCellCollapse = !sortCellCollapse

            if(sortCellCollapse == true){
                self.sortOptionIdx = indexPath.row
            }

            self.tableView.reloadSections(sectionToReload, withRowAnimation: .Automatic)

//            tableView.reloadData()
        }

        if(indexPath.section == 3){
            if(cuisineCategoryCollapse == true){
                if(indexPath.row == 3){
                    cuisineCategoryCollapse = false
//                    self.tableView.reloadSections(sectionToReload, withRowAnimation: .Automatic)
                    tableView.reloadData()
                }
            }
        }
    }

    func cuisineCategoryCellDidToggle(cuisineCategoryCell: CuisineCategoryCell, newValue: Bool) {
        let indexPath = tableView.indexPathForCell(cuisineCategoryCell)!
        cuisineSwitchStates[indexPath.row] = newValue
    }



    @IBAction func didToggleYelpSwitch(sender: YelpSwitchButton) {
        self.isOfferDeal = !sender.on
        
    }


    @IBAction func didToggleDealSwitch(sender: AnyObject) {
        self.isOfferDeal = sender.on
    }



    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     
     }
     */
    
    
}
