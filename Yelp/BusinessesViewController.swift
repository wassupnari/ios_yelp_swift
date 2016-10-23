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
    var filteredBusinesses: [Business]?
    
    var searchController: UISearchController!
    
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
            self.filteredBusinesses = self.businesses
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
        if filteredBusinesses != nil {
            return filteredBusinesses!.count
        } else {
            return 0
        }
        
//        if businesses != nil {
//            return businesses.count
//        } else {
//            return 0
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        //cell.business = businesses[indexPath.row]
        cell.business = filteredBusinesses?[indexPath.row]
        
        return cell
    }
    
    //        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
    //            //repoTableView.deselectRow(at: indexPath, animated: true)
    //            // do something here
    //        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
//        filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
//            // If dataItem matches the searchText, return true to include it
//            return dataString.range(of: searchText, options: .caseInsensitive) != nil
//        })
        print("search text : \(searchText)")
        filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter {(item: Business) -> Bool in
            print("boolean : \(item.categories?.range(of: searchText, options: .caseInsensitive) != nil)")
            return item.categories?.range(of: searchText, options: .caseInsensitive) != nil
        }
        
        tableview.reloadData()
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
        let categories = filters["categories"] as? [String]
        
        Business.searchWithTerm(term: "Restaurants", sort: nil, categories: categories, deals: nil, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableview.reloadData()
            }
        )
    }
}
