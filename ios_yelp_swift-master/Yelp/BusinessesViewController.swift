//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit


class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    var searchBar : UISearchBar!
    var searchTerm: String?
    var businesses: [Business]!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("ABOUT TO EDIT")
        self.searchBar.setShowsCancelButton(true, animated: false)
        
    }// called when text starts editing
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("--DONE!!")
        self.searchBar.resignFirstResponder()
        //  self.loadData()
        
        if let search = searchTerm {
        Business.searchWithTerm(term: search , completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) // called when keyboard search button pressed
        
    {
        print("!!!DONE!!")
        self.searchBar.resignFirstResponder()
        self.searchBar.setShowsCancelButton(false, animated: false)
        
        
       // self.loadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        print("SEARSCHING", searchText)
        searchTerm = searchText
        self.searchBar.setShowsCancelButton(true, animated: false)
        
        if(searchText == ""){
          //  endpoint = originalEndpoint;
          //  isSearch = ""
        } else{
            
          //  endpoint = ""
          //  searchQuery = "&query=\(searchText)"
          //  isSearch = "/search"
        }
        
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) // called when cancel button pressed
    {
        
        self.searchBar.resignFirstResponder()
        
        
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.showsCancelButton = false
      //  endpoint = originalEndpoint;
      //  isSearch = ""
        
        // You could also change the position, frame etc of the searchBar
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(businesses != nil){
            return businesses.count
        } else {
            return 0
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {

        let categories = filters["categories"] as? [String]
        Business.searchWithTerm(term: "Restaurants", distance: 321, sort: YelpSortMode.highestRated, categories: categories, deals: nil, completion: { (businesses: [Business]?, error: Error?) -> Void in
                self.businesses = businesses
                self.tableView.reloadData()
            }
        )
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    
}
