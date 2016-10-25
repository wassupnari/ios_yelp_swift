//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate{

    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var businesses: [Business]!
    
    var searchController: UISearchController!
    var searchKeyword: String?
    
    var searchDeal: Bool?
    var searchSort: YelpSortMode?
    var searchRadius: Double?
    var searchCategories: [String]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Searchbar setup
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        // Tableview setup
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 120
        
        // Dismiss keyboard when there's dragging event on tableview
        tableview.keyboardDismissMode = .onDrag
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            self.tableview.reloadData()
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if filteredBusinesses != nil {
//            return filteredBusinesses!.count
//        } else {
//            return 0
//        }
        
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    //        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
    //            //repoTableView.deselectRow(at: indexPath, animated: true)
    //            // do something here
    //        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter {(item: Business) -> Bool in
//            return item.categories?.range(of: searchText, options: .caseInsensitive) != nil
//        }
        self.searchKeyword = searchText
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false;
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text != nil) {
            searchKeyword = searchBar.text!
            getRestaurantsFromAPI()
        }
        searchBar.endEditing(true)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        let navigationViewController = segue.destination as! UINavigationController
        let filtersViewController = navigationViewController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
     }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        searchDeal = (filters["deal"] as? Bool)!
        if (!searchDeal!) {
            searchDeal = nil
        }
        if(filters["sort"] != nil) {
            searchSort = YelpSortMode(rawValue: (filters["sort"] as? Int)!)
        }
        if(filters["radius"] != nil) {
            searchRadius = filters["radius"] as? Double
        } else {
            searchRadius = nil
        }
        searchCategories = filters["categories"] as? [String]
        getRestaurantsFromAPI()
    }
    
    func getRestaurantsFromAPI() {
        
        // Set default keyword as Restaurants
        if self.searchKeyword == nil {
            self.searchKeyword = "Restaurant"
        }
        
        Business.searchWithTerm(term: self.searchKeyword!, sort: searchSort, categories: self.searchCategories, deals: searchDeal, radius: self.searchRadius, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableview.reloadData()
            }
        )
    }
}
