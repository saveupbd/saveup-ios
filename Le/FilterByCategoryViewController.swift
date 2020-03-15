//
//  FilterByCategoryViewController.swift
//  Le
//
//  Created by Asif Seraje on 1/26/20.
//  Copyright © 2020 Munesan M. All rights reserved.
//

import UIKit

protocol FilterViewDelegate {
    func didSelect(category:String,id:String)
}
class FilterByCategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var filterTable: UITableView!
    var filterDel:FilterViewDelegate?
    var filterContentArray:[String]?
    var filterIdArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTable.delegate = self
        filterTable.dataSource = self
        self.filterTable.layer.borderColor = UIColor.black.cgColor
        self.filterTable.layer.borderWidth = 1
        self.filterTable.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterContentArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "filterCategoryCell", for: indexPath)
        if UserDefaults.standard.value(forKey: "filterSelectedRow") == nil{
            tableCell.accessoryType = .none
        }else{
            if indexPath.row == UserDefaults.standard.value(forKey: "filterSelectedRow") as! Int{
                tableCell.accessoryType = .checkmark
            }else{
                tableCell.accessoryType = .none
            }
        }
        
        tableCell.textLabel?.text = filterContentArray?[indexPath.row]
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "filterSelectedRow")
        self.dismiss(animated: true) {
            let indexPath = tableView.indexPathForSelectedRow!
            let currentCell = tableView.cellForRow(at: indexPath)
            //if currentCell?.textLabel!.text == "Cancel"
            self.filterDel?.didSelect(category: (currentCell?.textLabel!.text)!, id: self.filterIdArray[indexPath.row])
        }
    }

}
