//
//  ViewController.swift
//  DDSCovidNetwork4
//
//  Created by Ben Huggins on 6/23/21.
//

// DIFFABLE DATASOURCE TABLEVIEW POPULATED WITH COVID API NETWORK DATA.

// This is an example of how to implement Diffable DataSource from a Network Call, presenting to onto a TableView. I have created a clone of this project using the old DataSource method with cellForRowAt and numberOfRowsInSection with indexPath,
// the project query's tame Covid Dash API pulling the name of Countries and a corrsponding IOS number for unique identification
// for future netork calls


import UIKit

// The first thing to note when implementing Diffable DataSource to take a look at our Protocols.
// Notice that we are only calling UITableViewDelegate but NOT UITableViewDataSource. This is because
// we are only modifying the datasource, not the delegate. We will be giving our to be declared diffable datasource
// a snapshot of our data.

class ViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    // Declare an empty array of Country Objects to hold our incoming JSON Network Data that streams off the internet
    // From our network Manager. Think of this array that contains incoming data as going to be forming a sort of snapshot built
    // by diffable datasource and then applied to our tableView, very quickly, whenever data changes/ updated etc.
    // Diffable Data Source makes use of a hash Table. On a very quick high level description, a hash table allows
    // each piece of data to be mapped to a hash value. This hash value uniquely identifies said piece of data and can
    // basically respond to it's changes more efficiently with less lines of code. Also because of this
    // hashable monitoring concept there is now no need to ever call: tableView.reloadData(). If you notice in the basic example of
    // Covid Dash Query I actually call didSet on my data model as a kind of observer to monitor data changes. This is
    // a sort of Hack to attempt to accomplish the same thing.
    
    var countries = [Country]()
    // **1
    // First We need to setup either a tableView or a CollectionView since those are the only
    // Two Starting UI templates that are used in iOS Development
   
    // You must mark your data Model as Hashable notice I do so in Country.swift file.
    
    // Give your collectionView or TableView a reuse identifier just as you would if you were
    //implementing (cellForRowAt:) with (numberOfRowsInSection:) [The old way of managing dataSource]

    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    // **2 Remember the function (numberOfRowsInSection:) ?? We aren't using that anymore. First we are going to
    // declare our sections inside an enum because an enum is Hashable. I am starting with a single section to
    // make it easier to understand, just add: case second and so on to make more sections. I will be utlizing this
    // when we implement compostitional layout (explaining soon)
    
    enum Section {
        case first
    }
    
    // It is time For the Declaration of our Diffable DataSource.
    
    // NOICE BELOW WE HAVE <Section, Country>
    // THIS IS REALLY <Section (CALLS SECTION ENUM WHICH IS JUST first), Country (THIS IS OUR MODEL DATA>
    
    var dataSource: UITableViewDiffableDataSource<Section, Country>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        addSearchBar()
        getCountries()           // <-- Here I call a function called getCountries that contains a completionHandler that returns network data from our Network Manager
        tableView.delegate = self     // <-- NOTE!! IVE REMOVED tableView.dataSource = self   !!!
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        // Declare Data Source
        // Remember (cellForRowAt: ) after we declare diffable dataSource with {tableView(what we apply dds to), regular indexPath, and then our model data -> sent to UITABLEVIEWCELL }
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model -> UITableViewCell? in
            
            // This is the same as what's normally below cellForRowAt
            
            // however we are adding our name variable to model instead of something like
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = model.name
        return cell
        })
    }
    
    func addSearchBar() {
        
        let searchBar:UISearchBar = UISearchBar()
        //IF you want frame replace first line and comment "searchBar.sizeToFit()"
        //let searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 10, y: 10, width: headerView.frame.width-20, height: headerView.frame.height-20))
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        tableView.addSubview(searchBar)//Here change your view name
        
        
    }
    
    func setUpNavigation() {
     navigationItem.title = "DDS"
        self.navigationController?.navigationBar.barTintColor = .red
     self.navigationController?.navigationBar.isTranslucent = false
       
    }
    // Get Network data
    func getCountries() {
        NetworkManager.shared.getCountries { result in
           
            // This is result type
            switch result {
            case .success(let countries):
            
                self.countries = countries //***!!! The countries that we get back from network are being set to the countries array [] declared above
                print("🍔🍔🍔🍔🍔🍔\(self.countries)")
                
                // update DataSource
                
                // OK SO THIS IS INTERESTING, INSIDE THIS FUNCTIONS LOOP RIGHT AFTER WE SET OUR MODEL OBJECT ARRAY OF COUNTRY OBJECTS WE THEN JUST RANDOMLY CALL: self.updateDataSource() function that then creates a snapshot which is the new data of what we want changed, by appending our model data and the section that it lives in.
                // Then we apply this snapshot to our dataSource which then takes it and updates our tableView, only changing the data that needs to be changed and nothing else.
                self.updateDataSource()
                
                
              
            case .failure(let error):
                print(error.rawValue)
                // call the custom alert from here
            }
            
        }
    }
    
    func updateDataSource() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
        snapshot.appendSections([.first])
        snapshot.appendItems(countries)
        
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text changed")
        
        
    }

    
}


