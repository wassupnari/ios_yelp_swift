//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Nari Shin on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories: [[String:String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categories = yelpCategories()
        tableView.delegate = self
        tableView.dataSource = self
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
    }
    
    func yelpCategories() -> [[String:String]] {
        return [["name": "Name", "code": "Code"],
        ["name": "Korean", "code": "korean"]]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories != nil {
            return categories.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
        cell.switchLabel.text = categories[indexPath.row]["name"]
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
