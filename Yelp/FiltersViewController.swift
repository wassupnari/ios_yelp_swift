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
        
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
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
        
        print("section id : \(dataForItem[indexPath.section][indexPath.row])")
        
        cell.switchLabel.text = dataForItem[indexPath.section][indexPath.row]
        //let itemsInSection = data[indexPath.section][1]
        //cell.switchLabel.text = itemsInSection[indexPath.row]
//        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
        
        return cell
    }
    
    // MARK: Header view for sectioned tableview
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderViewIdentifier)! as UITableViewHeaderFooterView
        //header.textLabel?.text = data[section][0]
//        print("header : \(dataForHeader[section])")
//        header.textLabel?.text = dataForHeader[section]
        return dataForHeader[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        
        print("callback invoked")
        
        // Store switch on/off data from delegate callback
        switchStates[indexPath.row] = value
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
        return [["name": "Name", "code": "Code"],
                ["name": "Korean", "code": "korean"]]
    }
    
    func createDataForHeader() -> [String] {
        return ["Deal", "Distance", "Sort by", "Category"]
    }
    
    func createDataForItem() -> [[String]] {
        return [["deal"],
                ["0.5 miles", "1 mile"],
                ["Best Match"],
                ["Thai", "Korean"]]
    }

}
