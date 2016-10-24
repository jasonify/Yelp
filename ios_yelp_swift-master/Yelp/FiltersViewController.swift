//
//  FiltersViewController.swift
//  Yelp
//
//  Created by jason on 10/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit


@objc protocol FiltersViewControllerDelegate {
   @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])
    
}
class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , SwitchCellDelegate, ExpandCellDelegate, CheckmarkCellDelegate{

    
    weak var delegate: FiltersViewControllerDelegate?
    
    var isDeals = false
    
    // TODO: enum // constants or section
    // Distance
    var distanceExpanded = false
    var distanceSelected:Int = 0
    
    let SECTION_DEAL = 0
    let SECTION_DISTANCE = 1
    let SECTION_SORT = 2
    let SECTION_CATEGORY = 3
    
    var distances: [ (String, Decimal?)] = [
        ("Auto", nil),
        ("5 miles", 8046.72),
        ("10 miles", 8046.72*2),
        ("15 miles", 8046.72*3),
        ("20 miles", 8046.72*4),
    ]
    
    // SORT
    
    var sortExpanded = false
    var sortSelected = 0
    
    var sorts: [ (String, YelpSortMode)] = [
        ("Best Match", YelpSortMode.bestMatched),
        ("Distance", YelpSortMode.distance),
        ("Highest Rated", YelpSortMode.highestRated),
    ]
    
    
  
    // Categories
    var categories: [[String:String]]!
    var categoriesSwitchStates = [Int:Bool]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        categories = yelpCategories()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        
        // Do any additional setup after loading the view.
    }

    @IBAction func onSearchButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
        var filters = [String: AnyObject]()
        
        filters["deals"] = isDeals as AnyObject
        
        
        filters["distance"] =  distances[distanceSelected].1 as AnyObject?
        
        filters["sort"] =  sorts[sortSelected].1 as AnyObject

        
        var selectedCategories = [String]()
        for(row, isSelected) in categoriesSwitchStates {
            if(isSelected){
                selectedCategories.append(categories[row]["code"]!)
                
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject?
        }
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }
   
    
    func expandCell(expandCell: ExpandCell){
        let indexPath = tableView.indexPath(for: expandCell)!
        if indexPath.section == SECTION_DISTANCE {
            distanceExpanded = true
            
            UIView.setAnimationsEnabled(true)
            self.tableView.beginUpdates()
            self.tableView.reloadSections(NSIndexSet(index: SECTION_DISTANCE) as IndexSet, with: UITableViewRowAnimation.fade)
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(false)
            
        }
        
        if indexPath.section == SECTION_SORT {
            sortExpanded = true
            
            UIView.setAnimationsEnabled(true)
            self.tableView.beginUpdates()
            self.tableView.reloadSections(NSIndexSet(index: SECTION_SORT) as IndexSet, with: UITableViewRowAnimation.fade)
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(false)
            
        }

    }
    
    func checkmarkCell(checkmarkCell : CheckmarkCell) {
        let indexPath = tableView.indexPath(for: checkmarkCell)!
        
        print("sec--", indexPath.section)
        print("row--", indexPath.row)
        
       if(indexPath.section == SECTION_DISTANCE){
            distanceExpanded = false
            distanceSelected = indexPath.row
            
            UIView.setAnimationsEnabled(true)
            self.tableView.beginUpdates()
            self.tableView.reloadSections(NSIndexSet(index: SECTION_DISTANCE) as IndexSet, with: UITableViewRowAnimation.fade)
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(false)
            
            
        }
        
        if(indexPath.section == SECTION_SORT){
            sortExpanded = false
            sortSelected = indexPath.row
            
            UIView.setAnimationsEnabled(true)
            self.tableView.beginUpdates()
            self.tableView.reloadSections(NSIndexSet(index: SECTION_SORT) as IndexSet, with: UITableViewRowAnimation.fade)
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(false)
            
            
        }
        
        
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        

        if(indexPath.section == SECTION_DEAL){
            print("DEALS", value)
            isDeals = value
        } else {
            categoriesSwitchStates[indexPath.row] = value
        }
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
       // print("cell at")
        if(indexPath.section == SECTION_DEAL){
            return dealsCell(tableView, cellForRowAt: indexPath)
            
        }
        
        if(indexPath.section == SECTION_DISTANCE){
            return distanceCell(tableView, cellForRowAt: indexPath)
            
        }
        
        if(indexPath.section == SECTION_SORT){
            return sortCell(tableView, cellForRowAt: indexPath)
            
        }
        
        return categoriesCell(tableView, cellForRowAt: indexPath)
    }
    
    
    func sortCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If not expanded
        if sortExpanded {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckmarkCell", for: indexPath) as! CheckmarkCell
            cell.titleLabel.text = sorts[indexPath.row].0
            cell.delegate = self
            if(indexPath.row == sortSelected ){
                              cell.checkImage.image =  #imageLiteral(resourceName: "selectedcheck")
            } else{
                cell.checkImage.image =  #imageLiteral(resourceName: "check")
            
            }
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandCell", for: indexPath) as! ExpandCell
        let text = sorts[sortSelected].0
        cell.delegate = self
        cell.titleLabel.text = text
        return cell
        
    }
    
    
    func distanceCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If not expanded
        if distanceExpanded {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckmarkCell", for: indexPath) as! CheckmarkCell
            cell.titleLabel.text = distances[indexPath.row].0
            cell.delegate = self
            if(indexPath.row == distanceSelected ){
                cell.checkImage.image =  #imageLiteral(resourceName: "selectedcheck")
            } else{
                cell.checkImage.image =  #imageLiteral(resourceName: "check")
                    
            }
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandCell", for: indexPath) as! ExpandCell
        let text = distances[distanceSelected].0
        cell.delegate = self
        cell.titleLabel.text = text
        return cell
        
    }
    
    func dealsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        cell.labelSwitch.text = "Offering a Deal"
        cell.delegate = self
        cell.switchSwitch.isOn = isDeals
        return cell
    }
    
    func categoriesCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        cell.delegate = self
        cell.labelSwitch.text = categories[indexPath.row]["name"]
        
        cell.switchSwitch.isOn = categoriesSwitchStates[indexPath.row] ?? false
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Deals
        if(section == SECTION_DEAL){
            return 1
        }
        
        // Distance
        if section == SECTION_DISTANCE {
            if distanceExpanded {
                return distances.count
            } else {
                return 1
            }
        }
        
        if section == SECTION_SORT {
            if sortExpanded {
                return sorts.count
            } else {
                return 1
            }
        }
        
        
        
        // Last
        return categories.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
    
       
        return 4
    }
    
   
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
   
        let header =  tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader") as! TableSectionHeader
        if( section == SECTION_DEAL){
            header.xwtextLabel?.text = ""

        }
        
        
        if( section == SECTION_DISTANCE){
            header.xwtextLabel?.text = "Distance"
            
        }
        
        if( section == SECTION_SORT){
            header.xwtextLabel?.text = "Sort By"
            
        }
        
        if( section == SECTION_CATEGORY){
            header.xwtextLabel?.text = "Category"
            
        }
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(section == SECTION_DEAL){
            return 0
        }
        return 50
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func yelpCategories() -> [[String:String]] {
        return [["name" : "Afghan", "code": "afghani"],
                ["name" : "African", "code": "african"],
                ["name" : "American, New", "code": "newamerican"],
                ["name" : "American, Traditional", "code": "tradamerican"],
                ["name" : "Arabian", "code": "arabian"],
                ["name" : "Argentine", "code": "argentine"],
                ["name" : "Armenian", "code": "armenian"],
                ["name" : "Asian Fusion", "code": "asianfusion"],
                ["name" : "Asturian", "code": "asturian"],
                ["name" : "Australian", "code": "australian"],
                ["name" : "Austrian", "code": "austrian"],
                ["name" : "Baguettes", "code": "baguettes"],
                ["name" : "Bangladeshi", "code": "bangladeshi"],
                ["name" : "Barbeque", "code": "bbq"],
                ["name" : "Basque", "code": "basque"],
                ["name" : "Bavarian", "code": "bavarian"],
                ["name" : "Beer Garden", "code": "beergarden"],
                ["name" : "Beer Hall", "code": "beerhall"],
                ["name" : "Beisl", "code": "beisl"],
                ["name" : "Belgian", "code": "belgian"],
                ["name" : "Bistros", "code": "bistros"],
                ["name" : "Black Sea", "code": "blacksea"],
                ["name" : "Brasseries", "code": "brasseries"],
                ["name" : "Brazilian", "code": "brazilian"],
                ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                ["name" : "British", "code": "british"],
                ["name" : "Buffets", "code": "buffets"],
                ["name" : "Bulgarian", "code": "bulgarian"],
                ["name" : "Burgers", "code": "burgers"],
                ["name" : "Burmese", "code": "burmese"],
                ["name" : "Cafes", "code": "cafes"],
                ["name" : "Cafeteria", "code": "cafeteria"],
                ["name" : "Cajun/Creole", "code": "cajun"],
                ["name" : "Cambodian", "code": "cambodian"],
                ["name" : "Canadian", "code": "New)"],
                ["name" : "Canteen", "code": "canteen"],
                ["name" : "Caribbean", "code": "caribbean"],
                ["name" : "Catalan", "code": "catalan"],
                ["name" : "Chech", "code": "chech"],
                ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                ["name" : "Chicken Shop", "code": "chickenshop"],
                ["name" : "Chicken Wings", "code": "chicken_wings"],
                ["name" : "Chilean", "code": "chilean"],
                ["name" : "Chinese", "code": "chinese"],
                ["name" : "Comfort Food", "code": "comfortfood"],
                ["name" : "Corsican", "code": "corsican"],
                ["name" : "Creperies", "code": "creperies"],
                ["name" : "Cuban", "code": "cuban"],
                ["name" : "Curry Sausage", "code": "currysausage"],
                ["name" : "Cypriot", "code": "cypriot"],
                ["name" : "Czech", "code": "czech"],
                ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                ["name" : "Danish", "code": "danish"],
                ["name" : "Delis", "code": "delis"],
                ["name" : "Diners", "code": "diners"],
                ["name" : "Dumplings", "code": "dumplings"],
                ["name" : "Eastern European", "code": "eastern_european"],
                ["name" : "Ethiopian", "code": "ethiopian"],
                ["name" : "Fast Food", "code": "hotdogs"],
                ["name" : "Filipino", "code": "filipino"],
                ["name" : "Fish & Chips", "code": "fishnchips"],
                ["name" : "Fondue", "code": "fondue"],
                ["name" : "Food Court", "code": "food_court"],
                ["name" : "Food Stands", "code": "foodstands"],
                ["name" : "French", "code": "french"],
                ["name" : "French Southwest", "code": "sud_ouest"],
                ["name" : "Galician", "code": "galician"],
                ["name" : "Gastropubs", "code": "gastropubs"],
                ["name" : "Georgian", "code": "georgian"],
                ["name" : "German", "code": "german"],
                ["name" : "Giblets", "code": "giblets"],
                ["name" : "Gluten-Free", "code": "gluten_free"],
                ["name" : "Greek", "code": "greek"],
                ["name" : "Halal", "code": "halal"],
                ["name" : "Hawaiian", "code": "hawaiian"],
                ["name" : "Heuriger", "code": "heuriger"],
                ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                ["name" : "Hot Dogs", "code": "hotdog"],
                ["name" : "Hot Pot", "code": "hotpot"],
                ["name" : "Hungarian", "code": "hungarian"],
                ["name" : "Iberian", "code": "iberian"],
                ["name" : "Indian", "code": "indpak"],
                ["name" : "Indonesian", "code": "indonesian"],
                ["name" : "International", "code": "international"],
                ["name" : "Irish", "code": "irish"],
                ["name" : "Island Pub", "code": "island_pub"],
                ["name" : "Israeli", "code": "israeli"],
                ["name" : "Italian", "code": "italian"],
                ["name" : "Japanese", "code": "japanese"],
                ["name" : "Jewish", "code": "jewish"],
                ["name" : "Kebab", "code": "kebab"],
                ["name" : "Korean", "code": "korean"],
                ["name" : "Kosher", "code": "kosher"],
                ["name" : "Kurdish", "code": "kurdish"],
                ["name" : "Laos", "code": "laos"],
                ["name" : "Laotian", "code": "laotian"],
                ["name" : "Latin American", "code": "latin"],
                ["name" : "Live/Raw Food", "code": "raw_food"],
                ["name" : "Lyonnais", "code": "lyonnais"],
                ["name" : "Malaysian", "code": "malaysian"],
                ["name" : "Meatballs", "code": "meatballs"],
                ["name" : "Mediterranean", "code": "mediterranean"],
                ["name" : "Mexican", "code": "mexican"],
                ["name" : "Middle Eastern", "code": "mideastern"],
                ["name" : "Milk Bars", "code": "milkbars"],
                ["name" : "Modern Australian", "code": "modern_australian"],
                ["name" : "Modern European", "code": "modern_european"],
                ["name" : "Mongolian", "code": "mongolian"],
                ["name" : "Moroccan", "code": "moroccan"],
                ["name" : "New Zealand", "code": "newzealand"],
                ["name" : "Night Food", "code": "nightfood"],
                ["name" : "Norcinerie", "code": "norcinerie"],
                ["name" : "Open Sandwiches", "code": "opensandwiches"],
                ["name" : "Oriental", "code": "oriental"],
                ["name" : "Pakistani", "code": "pakistani"],
                ["name" : "Parent Cafes", "code": "eltern_cafes"],
                ["name" : "Parma", "code": "parma"],
                ["name" : "Persian/Iranian", "code": "persian"],
                ["name" : "Peruvian", "code": "peruvian"],
                ["name" : "Pita", "code": "pita"],
                ["name" : "Pizza", "code": "pizza"],
                ["name" : "Polish", "code": "polish"],
                ["name" : "Portuguese", "code": "portuguese"],
                ["name" : "Potatoes", "code": "potatoes"],
                ["name" : "Poutineries", "code": "poutineries"],
                ["name" : "Pub Food", "code": "pubfood"],
                ["name" : "Rice", "code": "riceshop"],
                ["name" : "Romanian", "code": "romanian"],
                ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                ["name" : "Rumanian", "code": "rumanian"],
                ["name" : "Russian", "code": "russian"],
                ["name" : "Salad", "code": "salad"],
                ["name" : "Sandwiches", "code": "sandwiches"],
                ["name" : "Scandinavian", "code": "scandinavian"],
                ["name" : "Scottish", "code": "scottish"],
                ["name" : "Seafood", "code": "seafood"],
                ["name" : "Serbo Croatian", "code": "serbocroatian"],
                ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                ["name" : "Singaporean", "code": "singaporean"],
                ["name" : "Slovakian", "code": "slovakian"],
                ["name" : "Soul Food", "code": "soulfood"],
                ["name" : "Soup", "code": "soup"],
                ["name" : "Southern", "code": "southern"],
                ["name" : "Spanish", "code": "spanish"],
                ["name" : "Steakhouses", "code": "steak"],
                ["name" : "Sushi Bars", "code": "sushi"],
                ["name" : "Swabian", "code": "swabian"],
                ["name" : "Swedish", "code": "swedish"],
                ["name" : "Swiss Food", "code": "swissfood"],
                ["name" : "Tabernas", "code": "tabernas"],
                ["name" : "Taiwanese", "code": "taiwanese"],
                ["name" : "Tapas Bars", "code": "tapas"],
                ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                ["name" : "Tex-Mex", "code": "tex-mex"],
                ["name" : "Thai", "code": "thai"],
                ["name" : "Traditional Norwegian", "code": "norwegian"],
                ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                ["name" : "Trattorie", "code": "trattorie"],
                ["name" : "Turkish", "code": "turkish"],
                ["name" : "Ukrainian", "code": "ukrainian"],
                ["name" : "Uzbek", "code": "uzbek"],
                ["name" : "Vegan", "code": "vegan"],
                ["name" : "Vegetarian", "code": "vegetarian"],
                ["name" : "Venison", "code": "venison"],
                ["name" : "Vietnamese", "code": "vietnamese"],
                ["name" : "Wok", "code": "wok"],
                ["name" : "Wraps", "code": "wraps"],
                ["name" : "Yugoslav", "code": "yugoslav"]]
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation


}
