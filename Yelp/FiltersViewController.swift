//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Nari Shin on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    
    var categories: [[String:String]]!
    var sectionedSwitchStates = [[Int:Bool]]()
    var switchStates = [Int:Bool]()
    var dataForHeader: [String]!
    var dataForItem: [[String]]!
    
    // For sectioned tableview
//    let CellIdentifier = "SwitchCell", HeaderViewIdentifier = "TableViewHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataForHeader = createDataForHeader()
        dataForItem = createDataForItem()
        categories = yelpCategories()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        sectionedSwitchStates = initSwitchStates()
        
        // Sectioned tableview
        //tableView.register(SwitchCell.self, forCellReuseIdentifier: CellIdentifier)
        //tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelClicked(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSearchClicked(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        var filters = [String:AnyObject]()
        
        var selectedDeal = false
        var selectedSortBy = -1
        var selectedDistance = -1.0;
        var selectedCategories = [String]()
        
        var sectionIndex = 0
        for (object) in self.sectionedSwitchStates {
            switch sectionIndex {
            case 0:
                for(row, isSelected) in object {
                    if row == 0 {
                        selectedDeal = isSelected
                    }
                }
                break
            case 1:
                var distance = ""
                for(row, isSelected) in object {
                    if isSelected && row != 0 {
                        distance = dataForItem[1][row]
                    }
                }
                if(distance != "") {
                    let fullString: [String] = distance.components(separatedBy: " ")
                    selectedDistance = Double(fullString[0])! * 1609.34
                    print("distance : \(selectedDistance)")
                }
                break
            case 2:
                for(row, isSelected) in object {
                    if isSelected {
                        selectedSortBy = row
                    }
                }
                break
            case 3:
                for(row, isSelected) in object {
                    if isSelected {
                        selectedCategories.append(categories[row]["code"]!)
                    }
                }
                break
            default:
                selectedCategories.removeAll()
                
            }
            sectionIndex += 1
        }
        
        
        // For Categories
//        for (row, isSelected) in switchStates {
//            print("row : \(row)")
//            if isSelected {
//                selectedCategories.append(categories[row]["code"]!)
//            }
//        }
    
        // Deal filter
        filters["deal"] = selectedDeal as AnyObject?
        
        // Sort by filter
        if selectedSortBy > -1 {
            filters["sort"] = selectedSortBy as AnyObject?
        }
        
        // Distance filter
        if selectedDistance > 0 {
            filters["radius"] = selectedDistance as AnyObject?
        }
    
        // Category filter
        if selectedCategories.count > 0 {
            print("has category")
            filters["categories"] = selectedCategories as AnyObject?
        }
        
        delegate?.filtersViewController?(filtersViewController: self , didUpdateFilters: filters)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataForHeader.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataForItem[section].count
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if categories != nil {
//            return categories.count
//        } else {
//            return 0
//        }
//    }
    
    // MARK: Sectioned item view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
        cell.switchLabel.text = dataForItem[indexPath.section][indexPath.row]
        //let itemsInSection = data[indexPath.section][1]
        //cell.switchLabel.text = itemsInSection[indexPath.row]
//        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        //cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
        cell.onSwitch.isOn = sectionedSwitchStates[indexPath.section][indexPath.row] ?? false
        
        return cell
    }
    
    // MARK: Header view for sectioned tableview
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataForHeader[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        
        print("callback invoked, value : \(value)")
        // Store switch on/off data from delegate callback
        //switchStates[indexPath.row] = value
        sectionedSwitchStates[indexPath.section][indexPath.row] = value
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func yelpCategories() -> [[String:String]] {
        return [["name": "American", "code": "american"],
                ["name": "French", "code": "french"],
                ["name": "Japanese", "code": "japanese"],
                ["name": "Korean", "code": "korean"],
                ["name": "Mexican", "code": "mexican"],
                ["name": "Thai", "code": "thai"]]
    }
    
    func createDataForHeader() -> [String] {
        return ["Deal", "Distance", "Sort By", "Category"]
    }
    
    func createDataForItem() -> [[String]] {
        return [["Deal"],
                ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"],
                ["Best Match", "Distance", "Highest Rated"],
                ["American", "French", "Japanese", "Korean", "Mexican", "Thai"]]
    }
    
    func initSwitchStates() -> [[Int:Bool]] {
        return [[0: false],
                [0: false, 1: false, 2: false, 3: false, 4: false],
                [0: false, 1: false, 2: false],
                [0: false, 1: false, 2: false, 3: false, 4: false, 5: false]]
    }

}
