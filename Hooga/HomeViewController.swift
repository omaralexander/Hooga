//
//  HomeViewController.swift
//  Hooga
//
//  Created by Omar Abbas on 12/10/16.
//  Copyright © 2016 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase
import Mapbox
import MapKit
import CoreLocation

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
       
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        
    }
}
class HomeViewController: UIViewController, MGLMapViewDelegate, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate {
    var clicked = false
    
    @IBOutlet var dropDownSearch: UIView!
   
    @IBOutlet var dropDownSearchView: UIView!
    
    @IBOutlet weak var navigationBarForSearch: UINavigationBar!
    @IBOutlet weak var searchAroundMe: UIButton!
   
    @IBOutlet weak var scrollViewForBoroughs: UIScrollView!
    @IBOutlet weak var brooklynImageButton: UIImageView!
    @IBOutlet weak var manhattanImageButton: UIImageView!
    @IBOutlet weak var queensImageButton: UIImageView!
    @IBOutlet weak var bronxImageButton: UIImageView!
    @IBOutlet weak var statenIslandImageButton: UIImageView!
 
    @IBOutlet weak var closePhotos: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var manhattanLabel: UILabel!
    @IBOutlet weak var brooklynLabel: UILabel!
    @IBOutlet weak var bronxLabel: UILabel!
    @IBOutlet weak var statenIslandLabel: UILabel!
    @IBOutlet weak var queensLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var privacyAlert: UIView!
    @IBOutlet weak var closePrivacyAlert: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue){
        
    }

    @IBOutlet var testView: UIView!
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var MenuButton: UIButton!
    @IBAction func mainButton(_ sender: UIButton) {
     animateIn()
     
    }
    @IBAction func userLocationButton(_ sender: UIButton) {
        
        let manager = CLLocationManager()
        
        switch CLLocationManager.authorizationStatus(){
       
        case.authorizedWhenInUse:
            manager.delegate = self
            manager.startUpdatingLocation()
            manager.desiredAccuracy = kCLLocationAccuracyBest;
            var userLocation:CLLocationCoordinate2D = (manager.location?.coordinate)!
            print("this is the location",userLocation)
            mapView.setCenter(userLocation, zoomLevel: 12, animated: true)
            mapView.showsUserLocation = true
            break
        case.notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to access this feature you need to allow Hooga to access your location while in use", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default, handler: {(action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            })
            alertController.addAction(openAction)
            self.present(alertController, animated: true, completion: nil)
            break
        default: manager.requestWhenInUseAuthorization()
        }
    }
    
    

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        let hour = NSCalendar.current.component(.hour, from: NSDate() as Date)
//        
//        switch hour{
//        case 1...6: return.lightContent
//            
//        case 7...18: return.lightContent
//            
//        case 19...24,0: return.lightContent
//            
//        default: return.lightContent
//        }
//    }
   
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredCandies = [mapPoints]()
    
        var locations = [
    mapPoints(Borough: "Manhattan", Neighborhood: "Battery Park City", Latitude: 40.7117, Longitude: -74.0158),
    mapPoints(Borough: "Manhattan", Neighborhood: "Chelsea", Latitude: 40.7465, Longitude: -74.0014),
    mapPoints(Borough: "Manhattan", Neighborhood: "Chinatown", Latitude: 40.7158, Longitude: -73.9970),
    mapPoints(Borough: "Manhattan", Neighborhood: "East Harlem", Latitude: 40.7957, Longitude: -73.9389),
    mapPoints(Borough: "Manhattan", Neighborhood: "East Village", Latitude: 40.7265, Longitude: -73.9815),
    mapPoints(Borough: "Manhattan", Neighborhood: "Financial District", Latitude: 40.7075, Longitude: -74.0113),
    mapPoints(Borough: "Manhattan", Neighborhood: "Flatiron District", Latitude: 40.7401, Longitude: -73.9903),
    mapPoints(Borough: "Manhattan", Neighborhood: "Garment District", Latitude: 40.7547, Longitude: -73.9916),
    mapPoints(Borough: "Manhattan", Neighborhood: "Gramercy Park", Latitude: 40.7368, Longitude: -73.9845),
    mapPoints(Borough: "Manhattan", Neighborhood: "Greenwich Village", Latitude: 40.7336, Longitude: -74.0027),
    mapPoints(Borough: "Manhattan", Neighborhood: "Harlem", Latitude: 40.8116, Longitude: -73.9465),
    mapPoints(Borough: "Manhattan", Neighborhood: "Hell's Kitchen", Latitude: 40.7638, Longitude: -73.9918),
    mapPoints(Borough: "Manhattan", Neighborhood: "Inwood", Latitude: 40.8677, Longitude: -73.9212),
    mapPoints(Borough: "Manhattan", Neighborhood: "Kips Bay", Latitude: 40.7423, Longitude: -73.9801),
    mapPoints(Borough: "Manhattan", Neighborhood: "Little Italy", Latitude: 40.7191, Longitude: -73.9973),
    mapPoints(Borough: "Manhattan", Neighborhood: "Lower Manhattan", Latitude: 40.7230, Longitude: -74.0006),
    mapPoints(Borough: "Manhattan", Neighborhood: "Lower East Side", Latitude: 40.7150, Longitude: -73.9843),
    mapPoints(Borough: "Manhattan", Neighborhood: "Meatpacking District", Latitude: 40.7410, Longitude: -74.0076),
    mapPoints(Borough: "Manhattan", Neighborhood: "Midtown", Latitude: 40.7549, Longitude: -73.9840),
    mapPoints(Borough: "Manhattan", Neighborhood: "Morningside Heights", Latitude: 40.8090, Longitude: -73.9624),
    mapPoints(Borough: "Manhattan", Neighborhood: "Murray Hill", Latitude: 40.7665, Longitude: -73.8037),
    mapPoints(Borough: "Manhattan", Neighborhood: "NoHo", Latitude: 40.7287, Longitude: -73.9926),
    mapPoints(Borough: "Manhattan", Neighborhood: "NoLita", Latitude: 40.7230, Longitude: -73.9949),
    mapPoints(Borough: "Manhattan", Neighborhood: "Rockefeller Center", Latitude: 40.7587, Longitude: -73.9787),
    mapPoints(Borough: "Manhattan", Neighborhood: "Theatre District", Latitude: 40.7590, Longitude: -73.9845),
    mapPoints(Borough: "Manhattan", Neighborhood: "Tribeca", Latitude: 40.7163, Longitude: -74.0086),
    mapPoints(Borough: "Manhattan", Neighborhood: "Turtle Bay", Latitude: 40.7540, Longitude: -73.9668),
    mapPoints(Borough: "Manhattan", Neighborhood: "Union Square", Latitude: 40.7359, Longitude: -73.9911),
    mapPoints(Borough: "Manhattan", Neighborhood: "Upper East Side", Latitude: 40.7736, Longitude: -73.9566),
    mapPoints(Borough: "Manhattan", Neighborhood: "Upper West Side", Latitude: 40.7870, Longitude: -73.9754),
    mapPoints(Borough: "Manhattan", Neighborhood: "Washington Heights", Latitude: 40.8417, Longitude: -73.9394),
    mapPoints(Borough: "Manhattan", Neighborhood: "West Village", Latitude: 40.7358, Longitude: -74.0036),
    mapPoints(Borough: "Manhattan", Neighborhood: "Yorkville", Latitude: 43.1128, Longitude: -75.2710),
    mapPoints(Borough: "Manhattan", Neighborhood: "SoHo", Latitude: 40.7233, Longitude: -74.0030),
    
    mapPoints(Borough: "Brooklyn", Neighborhood: "Brooklyn Heights", Latitude: 40.6960, Longitude: -73.9933),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Bay Ridge", Latitude: 40.6262, Longitude: -74.0329),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Bedford-Stuyvesant", Latitude: 40.6872, Longitude: -73.9418),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Bensonhurst", Latitude: 40.6113, Longitude: -73.9977),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Boerum Hill", Latitude: 40.6849, Longitude: -73.9845),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Brighton Beach", Latitude: 40.5781, Longitude: -73.9597),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Bushwick", Latitude: 40.6944, Longitude: -73.9213),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Carroll Gardens", Latitude: 40.6795, Longitude: -73.9992),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Clinton Hill", Latitude: 40.6894, Longitude: -73.9639),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Cobble Hill", Latitude: 40.6865, Longitude: -73.9962),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Crown Heights", Latitude: 40.6681, Longitude: -73.9448),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Downtown Brooklyn", Latitude: 40.6960, Longitude: -73.9845),
    mapPoints(Borough: "Brooklyn", Neighborhood: "DUMBO", Latitude: 40.7033, Longitude: -73.9881),
    mapPoints(Borough: "Brooklyn", Neighborhood: "East New York", Latitude: 40.6568, Longitude: -73.8831),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Flatbush", Latitude: 40.6409, Longitude: -73.9624),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Fort Greene", Latitude: 40.6921, Longitude: -73.9742),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Gowanus", Latitude: 40.6733, Longitude: -73.9903),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Gravesend", Latitude: 40.5910, Longitude: -73.9771),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Greenpoint", Latitude: 40.7245, Longitude: -73.9419),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Kensington", Latitude: 40.6376, Longitude: -73.9742),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Park Slope", Latitude: 40.6681, Longitude: -73.9806),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Prospect- Lefferts Gardens", Latitude: 40.6590, Longitude: -73.9507),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Prospect Heights", Latitude: 40.6774, Longitude: -73.9668),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Red Hook", Latitude: 40.6773, Longitude: -74.0094),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Sunset Park", Latitude: 40.6455, Longitude: -74.0124),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Vinegar Hill", Latitude: 40.7037, Longitude: -73.9823),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Windsor Terrace", Latitude: 40.6539, Longitude: -73.9757),
    mapPoints(Borough: "Brooklyn", Neighborhood: "Williamsburg", Latitude: 40.7081, Longitude: -73.9571),
    
    mapPoints(Borough: "Queens", Neighborhood: "Astoria", Latitude: 40.7644, Longitude: -73.9235),
    mapPoints(Borough: "Queens", Neighborhood: "Auburndale", Latitude: 40.7541, Longitude: -73.7860),
    mapPoints(Borough: "Queens", Neighborhood: "Bayside", Latitude: 40.7586, Longitude: -73.7654),
    mapPoints(Borough: "Queens", Neighborhood: "Belle Harbor", Latitude: 40.5755, Longitude: -73.8507),
    mapPoints(Borough: "Queens", Neighborhood: "Bellerose", Latitude: 40.7320, Longitude: -73.7184),
    mapPoints(Borough: "Queens", Neighborhood: "College Point", Latitude: 40.7864, Longitude: -73.8390),
    mapPoints(Borough: "Queens", Neighborhood: "Corona", Latitude: 40.7450, Longitude: -73.8643),
    mapPoints(Borough: "Queens", Neighborhood: "Douglaston", Latitude: 40.7687, Longitude: -73.7471),
    mapPoints(Borough: "Queens", Neighborhood: "Flushing", Latitude: 40.7675, Longitude: -73.8331),
    mapPoints(Borough: "Queens", Neighborhood: "Forest Hills", Latitude: 40.7181, Longitude: -73.8448),
    mapPoints(Borough: "Queens", Neighborhood: "Forest Park", Latitude: 40.7000, Longitude: -73.8566),
    mapPoints(Borough: "Queens", Neighborhood: "Fresh Meadows", Latitude: 40.7335, Longitude: -73.7801),
    mapPoints(Borough: "Queens", Neighborhood: "Glendale", Latitude: 40.6990, Longitude: -73.8804),
    mapPoints(Borough: "Queens", Neighborhood: "Howard Beach", Latitude: 40.6571, Longitude: -73.8430),
    mapPoints(Borough: "Queens", Neighborhood: "Hunters Point", Latitude: 40.7480, Longitude: -73.9507),
    mapPoints(Borough: "Queens", Neighborhood: "Jackson Heights", Latitude: 40.7557, Longitude: -73.8831),
    mapPoints(Borough: "Queens", Neighborhood: "Jamaica Estates", Latitude: 40.7179, Longitude: -73.7743),
    mapPoints(Borough: "Queens", Neighborhood: "Jamaica", Latitude: 40.7027, Longitude: -73.7890),
    mapPoints(Borough: "Queens", Neighborhood: "Kew Gardens", Latitude: 40.7057, Longitude: -73.8272),
    mapPoints(Borough: "Queens", Neighborhood: "Laurelton", Latitude: 40.6741, Longitude: -73.7448),
    mapPoints(Borough: "Queens", Neighborhood: "Long Island City", Latitude: 40.7447, Longitude: -73.9485),
    mapPoints(Borough: "Queens", Neighborhood: "Maspeth", Latitude: 40.7294, Longitude: -73.9066),
    mapPoints(Borough: "Queens", Neighborhood: "Middle Village", Latitude: 40.7174, Longitude: -73.8743),
    mapPoints(Borough: "Queens", Neighborhood: "Queens Village", Latitude: 40.7157, Longitude: -73.7419),
    mapPoints(Borough: "Queens", Neighborhood: "Rego Park", Latitude: 40.7256, Longitude: -73.8625),
    mapPoints(Borough: "Queens", Neighborhood: "Richmond Hill", Latitude: 40.6958, Longitude: -73.8272),
    mapPoints(Borough: "Queens", Neighborhood: "Ridgewood", Latitude: 40.7044, Longitude: -73.9018),
    mapPoints(Borough: "Queens", Neighborhood: "Sunnyside", Latitude: 40.7433, Longitude: -73.9196),
    mapPoints(Borough: "Queens", Neighborhood: "Whitestone", Latitude: 40.7920, Longitude: -73.8096),
    mapPoints(Borough: "Queens", Neighborhood: "Woodhaven", Latitude: 40.6901, Longitude: -73.8566),
    mapPoints(Borough: "Queens", Neighborhood: "Woodside", Latitude: 40.7512, Longitude: -73.9036),
    
    mapPoints(Borough: "Bronx", Neighborhood: "Allerton", Latitude: 40.8637, Longitude: -73.8625),
    mapPoints(Borough: "Bronx", Neighborhood: "Baychester", Latitude: 40.8694, Longitude: -73.8331),
    mapPoints(Borough: "Bronx", Neighborhood: "Bedford Park", Latitude: 40.8701, Longitude: -73.8857),
    mapPoints(Borough: "Bronx", Neighborhood: "Belmont", Latitude: 40.8523, Longitude: -73.8860),
    mapPoints(Borough: "Bronx", Neighborhood: "Castle Hill", Latitude: 40.8177, Longitude: -73.8507),
    mapPoints(Borough: "Bronx", Neighborhood: "Clason Point", Latitude: 40.8144, Longitude: -73.8625),
    mapPoints(Borough: "Bronx", Neighborhood: "Co-op City", Latitude: 40.8739, Longitude: -73.8294),
    mapPoints(Borough: "Bronx", Neighborhood: "Country Club", Latitude: 40.8431, Longitude: -73.8213),
    mapPoints(Borough: "Bronx", Neighborhood: "Eastchester", Latitude: 40.8833, Longitude: -73.8272),
    mapPoints(Borough: "Bronx", Neighborhood: "Fieldston", Latitude: 40.8943, Longitude: -73.9036),
    mapPoints(Borough: "Bronx", Neighborhood: "Fordham", Latitude: 40.8579, Longitude: -73.8992),
    mapPoints(Borough: "Bronx", Neighborhood: "Highbridge", Latitude: 40.8385, Longitude: -73.9272),
    mapPoints(Borough: "Bronx", Neighborhood: "Hunts Point", Latitude: 40.8120, Longitude: -73.8801),
    mapPoints(Borough: "Bronx", Neighborhood: "Kingsbridge", Latitude: 40.8834, Longitude: -73.9051),
    mapPoints(Borough: "Bronx", Neighborhood: "Longwood", Latitude: 40.8248, Longitude: -73.8916),
    mapPoints(Borough: "Bronx", Neighborhood: "Melrose", Latitude: 40.8210, Longitude: -73.9169),
    mapPoints(Borough: "Bronx", Neighborhood: "Morris Heights", Latitude: 40.8516, Longitude: -73.9154),
    mapPoints(Borough: "Bronx", Neighborhood: "Morris Park", Latitude: 40.8522, Longitude: -73.8507),
    mapPoints(Borough: "Bronx", Neighborhood: "Morrisania", Latitude: 40.8251, Longitude: -73.9110),
    mapPoints(Borough: "Bronx", Neighborhood: "Mott Haven", Latitude: 40.8091, Longitude: -73.9229),
    mapPoints(Borough: "Bronx", Neighborhood: "Norwood", Latitude: 40.8771, Longitude: -73.8787),
    mapPoints(Borough: "Bronx", Neighborhood: "Parkchester", Latitude: 40.8383, Longitude: -73.8566),
    mapPoints(Borough: "Bronx", Neighborhood: "Pelham Bay", Latitude: 40.8497, Longitude: -73.8331),
    mapPoints(Borough: "Bronx", Neighborhood: "Pelham Gardens", Latitude: 40.8612, Longitude: -73.8448),
    mapPoints(Borough: "Bronx", Neighborhood: "Pelham Parkway", Latitude: 40.8553, Longitude: -73.8640),
    mapPoints(Borough: "Bronx", Neighborhood: "Port Morris", Latitude: 40.8029, Longitude: -73.9110),
    mapPoints(Borough: "Bronx", Neighborhood: "Riverdale", Latitude: 40.8941, Longitude: -73.9110),
    mapPoints(Borough: "Bronx", Neighborhood: "Soundview", Latitude: 40.8251, Longitude: -73.8684),
    mapPoints(Borough: "Bronx", Neighborhood: "Spuyten Duyvil", Latitude: 40.8812, Longitude: -73.9154),
    mapPoints(Borough: "Bronx", Neighborhood: "Throggs Neck", Latitude: 40.8184, Longitude: -73.8213),
    mapPoints(Borough: "Bronx", Neighborhood: "Tremont", Latitude: 40.8447, Longitude: -73.8934),
    mapPoints(Borough: "Bronx", Neighborhood: "University Heights", Latitude: 40.8596, Longitude: -73.9110),
    mapPoints(Borough: "Bronx", Neighborhood: "Van Nest", Latitude: 40.8416, Longitude: -73.8707),
    mapPoints(Borough: "Bronx", Neighborhood: "Wakefield", Latitude: 40.8965, Longitude: -73.8507),
    mapPoints(Borough: "Bronx", Neighborhood: "West Farms", Latitude: 40.8431, Longitude: -73.8816),
    mapPoints(Borough: "Bronx", Neighborhood: "Williamsbridge", Latitude: 40.8777, Longitude: -73.8566),
    mapPoints(Borough: "Bronx", Neighborhood: "Woodlawn", Latitude: 40.8976, Longitude: -73.8669),

    mapPoints(Borough: "Staten Island", Neighborhood: "Arden Heights", Latitude: 40.5568, Longitude: -74.1739),
    mapPoints(Borough: "Staten Island", Neighborhood: "Arrochar", Latitude: 40.5967, Longitude: -74.0704),
    mapPoints(Borough: "Staten Island", Neighborhood: "Bay Terrace", Latitude: 40.5560, Longitude: -74.1328),
    mapPoints(Borough: "Staten Island", Neighborhood: "Bulls Head", Latitude: 40.6097, Longitude: -74.1622),
    mapPoints(Borough: "Staten Island", Neighborhood: "Castleton Corners", Latitude: 40.6134, Longitude: -74.1216),
    mapPoints(Borough: "Staten Island", Neighborhood: "Clifton", Latitude: 40.6190, Longitude: -74.0785),
    mapPoints(Borough: "Staten Island", Neighborhood: "Dongan Hills", Latitude: 40.5907, Longitude: -74.0885),
    mapPoints(Borough: "Staten Island", Neighborhood: "Elm Park", Latitude: 40.6312, Longitude: -74.1387),
    mapPoints(Borough: "Staten Island", Neighborhood: "Eltingville", Latitude: 40.5394, Longitude: -74.1563),
    mapPoints(Borough: "Staten Island", Neighborhood: "Emerson Hill", Latitude: 40.6073, Longitude: -74.0961),
    mapPoints(Borough: "Staten Island", Neighborhood: "Grant City", Latitude: 40.5820, Longitude: -74.1049),
    mapPoints(Borough: "Staten Island", Neighborhood: "Grasmere", Latitude: 40.6042 , Longitude: -74.0838),
    mapPoints(Borough: "Staten Island", Neighborhood: "Great Kills", Latitude: 40.5543, Longitude: -74.1563),
    mapPoints(Borough: "Staten Island", Neighborhood: "Greenridge", Latitude: 40.5612, Longitude: -74.1699),
    mapPoints(Borough: "Staten Island", Neighborhood: "Grymes Hill", Latitude: 40.6187, Longitude: -74.0935),
    mapPoints(Borough: "Staten Island", Neighborhood: "Huguenot", Latitude: 40.5373, Longitude: -74.1946),
    mapPoints(Borough: "Staten Island", Neighborhood: "Lighthouse Hill", Latitude: 40.5773, Longitude: -74.1343),
    mapPoints(Borough: "Staten Island", Neighborhood: "Mariners Harbor", Latitude: 40.6336, Longitude: -74.1563),
    mapPoints(Borough: "Staten Island", Neighborhood: "Midland Beach", Latitude: 40.5715, Longitude: -74.0932),
    mapPoints(Borough: "Staten Island", Neighborhood: "New Brighton", Latitude: 40.6404, Longitude: -74.0902),
    mapPoints(Borough: "Staten Island", Neighborhood: "New Dorp", Latitude: 40.5733, Longitude: -74.1152),
    mapPoints(Borough: "Staten Island", Neighborhood: "New Springville", Latitude: 40.5890, Longitude: -74.1563),
    mapPoints(Borough: "Staten Island", Neighborhood: "Oakwood", Latitude: 40.5640, Longitude: -74.1160),
    mapPoints(Borough: "Staten Island", Neighborhood: "Pleasant Plains", Latitude: 40.5240, Longitude: -74.2157),
    mapPoints(Borough: "Staten Island", Neighborhood: "Port Richmond", Latitude: 40.6355, Longitude: -74.1255),
    mapPoints(Borough: "Staten Island", Neighborhood: "Randall Manor", Latitude: 40.6411, Longitude: -74.1034),
    mapPoints(Borough: "Staten Island", Neighborhood: "Richmond Valley", Latitude: 40.5201, Longitude: -74.2293),
    mapPoints(Borough: "Staten Island", Neighborhood: "Rosebank", Latitude: 40.6132, Longitude: -74.0726),
    mapPoints(Borough: "Staten Island", Neighborhood: "Rossville", Latitude: 40.5510, Longitude: -74.2033),
    mapPoints(Borough: "Staten Island", Neighborhood: "Silver Lake", Latitude: 40.6277, Longitude: -74.0933),
    mapPoints(Borough: "Staten Island", Neighborhood: "South Beach", Latitude: 40.5829, Longitude: -74.0739),
    mapPoints(Borough: "Staten Island", Neighborhood: "St.George", Latitude: 40.6427, Longitude: -74.0799),
    mapPoints(Borough: "Staten Island", Neighborhood: "Stapleton", Latitude: 40.6289, Longitude: -74.0785),
    mapPoints(Borough: "Staten Island", Neighborhood: "Sunnyside", Latitude: 40.6128, Longitude: -74.1049),
    mapPoints(Borough: "Staten Island", Neighborhood: "Todt Hill", Latitude: 40.6014, Longitude: -74.1034),
    mapPoints(Borough: "Staten Island", Neighborhood: "Tompkinsville", Latitude: 40.6326, Longitude: -74.0873),
     mapPoints(Borough: "Staten Island", Neighborhood: "Tottenville", Latitude: 40.5083, Longitude: -74.2355),
     mapPoints(Borough: "Staten Island", Neighborhood: "Travis", Latitude: 40.5890, Longitude: -74.1915),
     mapPoints(Borough: "Staten Island", Neighborhood: "West New Brighton", Latitude: 40.6270, Longitude: -74.1093),
     mapPoints(Borough: "Staten Island", Neighborhood: "Westerleigh", Latitude: 40.6212, Longitude: -74.1318),
     mapPoints(Borough: "Staten Island", Neighborhood: "Willowbrook", Latitude: 40.6032, Longitude: -74.1385)
        ]

  var filteredLocations = [mapPoints]()

   let viewTemp = UIView(frame: CGRect(x: 32, y: 18, width: UIScreen.main.bounds.width - 32, height: 44)) //44
    var titles = [String]()
    let manager = CLLocationManager()
    var effect: UIVisualEffect!
   
    var radiusDistanceNumber: Int?
    var originalSearchBarLocation: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
collectionView.isUserInteractionEnabled = false
        let screenWidth = self.view.frame.width
        let screenHeight = self.view.frame.height
        self.searchController.searchBar.delegate = self
        
        dropDownSearchView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.privacyAlert.layer.cornerRadius = 34
        closePrivacyAlert.addTarget(self, action: #selector(privacyAlertAnimateOut), for: .touchUpInside)
        privacyAlert.backgroundColor = UIColor.white
       let Cell = "Cell"
        collectionView.register(cellForLocations.self, forCellWithReuseIdentifier: Cell)
        searchAroundMe.layer.cornerRadius = 14
        searchAroundMe.clipsToBounds = false
        searchAroundMe.isHidden = false
        closePhotos.addTarget(self, action: #selector(resetImages), for: .touchUpInside)
        closePhotos.isHidden = true
        searchAroundMe.addTarget(self, action: #selector(myPlaces), for: .touchUpInside)
       
        viewTemp.addSubview(self.searchController.searchBar)
        self.dropDownSearch.addSubview(viewTemp)
        self.dropDownSearch.addSubview(cancelButton)
        scrollViewForBoroughs.contentSize.width = 972
        scrollViewForBoroughs.frame = CGRect(x: 0, y: 71, width: screenWidth, height: 53)
        tableView.delegate = self
        tableView.dataSource = self
        scrollViewForBoroughs.backgroundColor = UIColor.white
        
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.keyboardAppearance = .light
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        longPress.minimumPressDuration = 0.9
       mapView.addGestureRecognizer(longPress)
        
        
       
        
        let filteredLocationsCount = filteredLocations.count
        let multiplication = filteredLocationsCount * 335
       
        
        collectionView.contentSize.width = CGFloat(multiplication)

        let user = FIRAuth.auth()?.currentUser
        guard let uid = user?.uid else{
            return
        }
        let ref = FIRDatabase.database().reference().child("Users").child(uid)
        ref.observe(.value, with: { snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
            self.radiusDistanceNumber = dictionary["radiusDistance"] as? Int
            }})
        let greySearchColor = UIColor(red: 176/255, green: 190/255, blue: 200/255, alpha: 1)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.searchBarStyle = .minimal//.prominent
        self.searchController.searchBar.backgroundColor = UIColor.blue
        self.searchController.searchBar.isTranslucent = false
        self.searchController.searchBar.backgroundImage = UIImage()
        self.searchController.searchBar.barTintColor = greySearchColor //.white
        self.searchController.searchBar.tintColor = UIColor.white
        self.searchController.searchBar.placeholder = "Search locations to find users here"
     
        let textFieldInsideSearchBar = self.searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor.white
        textFieldInsideSearchBar?.font = UIFont(name: "Avenir-book", size: 16)
        textFieldInsideSearchBarLabel?.font = UIFont(name: "Avenir-book", size: 16)
        self.cancelButton.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        //self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64
       
        
        
        self.manhattanImageButton.contentMode = .scaleAspectFill
        self.manhattanImageButton.layer.cornerRadius = 14
        self.manhattanImageButton.clipsToBounds = true
        self.manhattanImageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(manhattanFunc)))
        
        
        self.brooklynImageButton.contentMode = .scaleAspectFill
        self.brooklynImageButton.layer.cornerRadius = 14
        self.brooklynImageButton.clipsToBounds = true
        self.brooklynImageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(brooklynFunc)))
        
        self.bronxImageButton.contentMode = .scaleAspectFill
        self.bronxImageButton.layer.cornerRadius = 14
        self.bronxImageButton.clipsToBounds = true
        self.bronxImageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bronxFunc)))
        
        
        self.queensImageButton.layer.cornerRadius = 14
        self.queensImageButton.clipsToBounds = true
        self.queensImageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(queensFunc)))
        
        self.statenIslandImageButton.contentMode = .scaleAspectFill
        self.statenIslandImageButton.layer.cornerRadius = 14
        self.statenIslandImageButton.clipsToBounds = true
        self.statenIslandImageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(statenIslandFunc)))
        
        

        
       // let darkStyle = NSURL(string: "mapbox://styles/omarsapp/civw071ue00052kqmuyn7xlp1")
        
        let lightStyle = NSURL(string: "mapbox://styles/omarsapp/civwz1qcs000x2kqm0megm5lm")
        
        let hour = NSCalendar.current.component(.hour, from: NSDate() as Date)
        
        switch hour {
        case 1...6: self.mapView.styleURL = lightStyle as URL?
                   break
        case 7...18:  self.mapView.styleURL = lightStyle as URL?
            break
        case 19...23, 0: self.mapView.styleURL = lightStyle as URL?
            break
        default: self.mapView.styleURL = lightStyle as URL!
                }
        
        mapView.delegate = self
        mapView.attributionButton.isHidden = true
        mapView.logoView.isHidden = true
        mapView.setUserTrackingMode(.follow, animated: false)
        mapView.zoomLevel = 10
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
      
        originalSearchBarLocation = searchAroundMe.frame
        
        if self.revealViewController() != nil {
            MenuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
          
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        switch CLLocationManager.authorizationStatus(){
            
        case.authorizedWhenInUse:
            manager.delegate = self
            manager.startUpdatingLocation()
            manager.desiredAccuracy = kCLLocationAccuracyBest;
            var userLocation:CLLocationCoordinate2D = (manager.location?.coordinate)!
            if manager.location == nil{
            print("no location at this time")
            }else{
            print("this is the location",userLocation)
            mapView.setCenter(userLocation, zoomLevel: 12, animated: true)
            mapView.showsUserLocation = true
            }
            break
        case.notDetermined:
            manager.requestWhenInUseAuthorization()
            
            break
        case .restricted, .denied:
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to access this feature you need to allow Hooga to access your location while in use", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        
            let openAction = UIAlertAction(title: "Open Settings", style: .default, handler: {(action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            })
            alertController.addAction(openAction)
            self.present(alertController, animated: true, completion: nil)
            break
        default: manager.requestWhenInUseAuthorization()
        }
}
    
    
    func removePointsAndClearArray(){
        collectionView.isUserInteractionEnabled = false
        if filteredLocations.count > 0{
            filteredLocations.removeAll()
            mapView.removeAnnotations(self.mapView.annotations!)
            
            collectionView.reloadData()
        }else{
          print("no points in here")
        }
    }
    func removePointsAndMoveCollectionView(){
        collectionView.isUserInteractionEnabled = false
        if filteredLocations.count > 0{
            filteredLocations.removeAll()
            mapView.removeAnnotations(self.mapView.annotations!)
            collectionView.reloadData()
            mapView.setCenter((mapView.userLocation?.coordinate)!, zoomLevel: 10, animated: true)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                
                            })
        }else{
            print("no points in here")
        }

    }
    func addAnnotation(gestureRecognizer: UIGestureRecognizer){
       
        
        let refined = Double(5)
       
     
        if gestureRecognizer.state == UIGestureRecognizerState.began{
            removePointsAndClearArray()
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let longPressAnnotation = MGLPointAnnotation()
            longPressAnnotation.coordinate = newCoordinates
            longPressAnnotation.title = "Selected location"
            
            
            filteredLocations = locations.filter {
                (location) in
                let userLocation = newCoordinates
                let userLat = userLocation.latitude
                let userLong = userLocation.longitude
                
                let coordinateOne = CLLocation(latitude: userLat, longitude: userLong)
                let coordinateTwo = CLLocation(latitude: location.latitude, longitude: location.longitude)
                
                let distanceFromPoints = coordinateOne.distance(from: coordinateTwo)
                let convertToMiles = distanceFromPoints*0.00062137
                
                return convertToMiles < refined
                
            }
            
            filteredLocations.map {
                (location) in
                let annotation = MGLPointAnnotation()
                annotation.title = location.Neighborhood
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                mapView.addAnnotation(annotation)
                mapView.setCenter(newCoordinates,zoomLevel:11, animated:true)
                
            }
            
            if filteredLocations.count <= 0 {
                collectionView.isUserInteractionEnabled = false
            }else{
                collectionView.isUserInteractionEnabled = true
            }
            
            collectionView.reloadData()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
              
               
            })
        
    }
}

    func myPlaces(){
        let refined = Double(radiusDistanceNumber!)

        let manager = CLLocationManager()
        
        switch CLLocationManager.authorizationStatus(){
            
        case.authorizedWhenInUse:
            
            filteredLocations = locations.filter {
                (location) in
                manager.delegate = self
                manager.startUpdatingLocation()
                manager.desiredAccuracy = kCLLocationAccuracyBest;
                var userLocation:CLLocationCoordinate2D = (manager.location?.coordinate)!
                print("this is the location",userLocation)
                mapView.showsUserLocation = true
                
                let userLat = userLocation.latitude
                let userLong = userLocation.longitude
                
                let coordinateOne = CLLocation(latitude: userLat, longitude: userLong)
                let coordinateTwo = CLLocation(latitude: location.latitude, longitude: location.longitude)
                
                let distanceFromPoints = coordinateOne.distance(from: coordinateTwo)
                let convertToMiles = distanceFromPoints*0.00062137
                
                return convertToMiles < refined
                
            }
            
            filteredLocations.map {
                (location) in
                let annotation = MGLPointAnnotation()
                annotation.title = location.Neighborhood
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                mapView.addAnnotation(annotation)
                mapView.setCenter((mapView.userLocation?.coordinate)!,zoomLevel:11, animated:true)
                
            }
            if filteredLocations.count <= 0 {
                collectionView.isUserInteractionEnabled = false
            }else{
                collectionView.isUserInteractionEnabled = true
            }

            collectionView.reloadData()
            animateOut()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                
                
            })
            

            break
        case.notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to access this feature you need to allow Hooga to access your location while in use", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default, handler: {(action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            })
            alertController.addAction(openAction)
            collectionView.reloadData()
            animateOut()
            self.present(alertController, animated: true, completion: nil)
            break
        default: manager.requestWhenInUseAuthorization()
        }
}

    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        var annotationView = mapView.dequeueReusableAnnotationImage(withIdentifier: "pisa")
        if annotationView == nil {
            
        var image = UIImage(named: "pisavector")!
            
        image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
            
        annotationView = MGLAnnotationImage(image: image, reuseIdentifier: "pisa")
        
        
        }
        return annotationView
    }


    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
        }
    
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> UIView? {
        return nil
    }
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        if (annotation.title! == "Test title") {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 50))
            label.textAlignment = .right
            label.textColor = UIColor(red: 0.81, green: 0.71, blue: 0.23, alpha: 1)
            label.text = ""
            
            
            return label
        }
        
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        var button = UIButton(type:.custom)
          button = UIButton(frame: CGRect(x: 100, y: 100, width: 20, height: 25)) //5050
        
        let btnImage = UIImage(named: "annotationNext")
        let btnview = UIImageView(image: btnImage)
        button.setBackgroundImage(btnImage, for: .normal)
        button.setImage(btnImage, for: .normal)
        
        
        btnview.frame = CGRect(x: 100, y: 100, width: 20, height: 20)
        button.addSubview(btnview)
      
        
        return button
    }

    
        func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {

            if annotation is MGLUserLocation{
                print("do nothign")
            }
            if (annotation.title! == "Test title"){
            print("nothing")
            }
            
            
            performSegue(withIdentifier: "annotationViewSegue", sender: annotation)
            
            
            
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.delegate = self
            manager.startUpdatingLocation()
            manager.desiredAccuracy = kCLLocationAccuracyBest;
            var userLocation:CLLocationCoordinate2D = (manager.location?.coordinate)!
            print("this is the location",userLocation)
            mapView.showsUserLocation = true

            //do whatever init activities here.
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.delegate = self
        manager.startUpdatingLocation()
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        var userLocation:CLLocationCoordinate2D = (manager.location?.coordinate)!
        print("this is the location",userLocation)
        mapView.showsUserLocation = true

        print("Did location updates is called")
        //store the user location here to firebase or somewhere
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    func testFunction(){
       performSegue(withIdentifier: "annotationViewSegue", sender: self)

    }
    func animateIn() {
        self.view.addSubview(dropDownSearch)
        dropDownSearch.center = self.view.center
        dropDownSearch.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        dropDownSearch.alpha = 0
       
        UIView.animate(withDuration:0.4){
            self.dropDownSearch.alpha = 1
            self.dropDownSearch.transform = CGAffineTransform.identity
            self.viewTemp.isHidden = false
            self.searchController.searchBar.isHidden = false
            
            
        }
        
    }
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.dropDownSearch.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.dropDownSearch.alpha = 0
        }) { (success:Bool) in
            self.dropDownSearch.willRemoveSubview(self.viewTemp)
            self.dropDownSearch.removeFromSuperview()
            self.viewTemp.isHidden = true
            self.searchController.searchBar.isHidden = true
            self.searchController.isActive = false
            self.resignFirstResponder()
        }
    }
    
    func manhattanFunc(){
        let screenWidth = self.view.frame.width
       cancelButton.isHidden = true
        closePhotos.isHidden = false
        viewTemp.isHidden = true
      searchController.searchBar.isHidden = true
        
            self.searchController.isActive = true
            
      
            self.searchController.searchBar.text = "Manhattan";
        
       
        
        
        self.dropDownSearch.willRemoveSubview(viewTemp)
        self.dropDownSearch.willRemoveSubview(bronxImageButton)
        self.dropDownSearch.willRemoveSubview(bronxLabel)
        
        self.dropDownSearch.willRemoveSubview(brooklynImageButton)
        self.dropDownSearch.willRemoveSubview(brooklynLabel)
        
        self.dropDownSearch.willRemoveSubview(queensImageButton)
        self.dropDownSearch.willRemoveSubview(queensLabel)
        
        self.dropDownSearch.willRemoveSubview(statenIslandImageButton)
        self.dropDownSearch.willRemoveSubview(statenIslandLabel)

        self.scrollViewForBoroughs.willRemoveSubview(manhattanImageButton)
        self.scrollViewForBoroughs.willRemoveSubview(manhattanLabel)
        
        self.scrollViewForBoroughs.addSubview(brooklynImageButton)
        self.scrollViewForBoroughs.addSubview(brooklynLabel)
        
        self.scrollViewForBoroughs.addSubview(queensImageButton)
        self.scrollViewForBoroughs.addSubview(queensLabel)
        
        self.scrollViewForBoroughs.addSubview(bronxImageButton)
        self.scrollViewForBoroughs.addSubview(bronxLabel)
        
        self.scrollViewForBoroughs.addSubview(statenIslandImageButton)
        self.scrollViewForBoroughs.addSubview(statenIslandLabel)
        
        self.dropDownSearch.addSubview(manhattanImageButton)
        self.dropDownSearch.addSubview(manhattanLabel)
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseIn, animations: {
        
            self.manhattanImageButton.frame = CGRect(x: 0, y: 0, width: screenWidth + 10, height: 71)//55
            self.manhattanImageButton.layer.cornerRadius = 0
            self.manhattanLabel.frame = CGRect(x: 0, y: 0, width: screenWidth + 10, height:71)
            self.manhattanLabel.font = self.manhattanLabel.font.withSize(22)
            // 0 71 375 53

            self.scrollViewForBoroughs.frame = CGRect(x: 500, y: 71, width: screenWidth + 10, height: 53)
           // 5 136 365 48
            
            self.brooklynImageButton.frame = CGRect(x: 3, y: Int(1.5), width: 188, height: 50)
            self.brooklynLabel.frame = CGRect(x: 3, y: Int(1.5), width: 188, height: 50)
            self.brooklynLabel.font = self.brooklynLabel.font.withSize(17)
            
            self.queensImageButton.frame = CGRect(x: 196, y: 1.5, width: 188, height: 50)
            self.queensLabel.frame = CGRect(x: 196, y: 1.5, width: 188, height: 50)
            self.queensLabel.font = self.queensLabel.font.withSize(17)

            self.bronxImageButton.frame = CGRect(x: 389, y: 1.5, width: 188, height: 50)
            self.bronxLabel.frame = CGRect(x: 389, y: 1.5, width: 188, height: 50)
            self.bronxLabel.font = self.bronxLabel.font.withSize(17)
            
            self.statenIslandImageButton.frame = CGRect(x: 582, y: 1.5, width: 188, height: 50)
            self.statenIslandLabel.frame = CGRect(x: 582, y: 1.5, width: 188, height: 50)
            self.statenIslandLabel.font = self.statenIslandLabel.font.withSize(17)
           
            self.brooklynImageButton.layer.cornerRadius = 14
            self.queensImageButton.layer.cornerRadius = 14
            self.bronxImageButton.layer.cornerRadius = 14
            self.statenIslandImageButton.layer.cornerRadius = 14
            self.scrollViewForBoroughs.contentSize.width = 779
            self.dropDownSearch.addSubview(self.closePhotos)
        }, completion: nil)
         UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.searchAroundMe.isHidden = false
            self.searchAroundMe.frame = CGRect(x: 5, y: 75, width: screenWidth, height: 48)
         }, completion: nil)
        
        print("ALL good here")
        tableView.reloadData()
    }
    func brooklynFunc(){
        let screenWidth = self.view.frame.width
        cancelButton.isHidden = true
        closePhotos.isHidden = false
        viewTemp.isHidden = true
        searchController.searchBar.isHidden = true
        self.searchController.isActive = true
        self.searchController.searchBar.text = "Brooklyn";
        
        
        self.scrollViewForBoroughs.willRemoveSubview(brooklynImageButton)
        self.scrollViewForBoroughs.willRemoveSubview(brooklynLabel)
        
        self.scrollViewForBoroughs.addSubview(manhattanImageButton)
        self.scrollViewForBoroughs.addSubview(manhattanLabel)
        
        self.scrollViewForBoroughs.addSubview(queensImageButton)
        self.scrollViewForBoroughs.addSubview(queensLabel)
        
        self.scrollViewForBoroughs.addSubview(bronxImageButton)
        self.scrollViewForBoroughs.addSubview(bronxLabel)
        
        self.scrollViewForBoroughs.addSubview(statenIslandImageButton)
        self.scrollViewForBoroughs.addSubview(statenIslandLabel)
        
        self.dropDownSearch.addSubview(brooklynImageButton)
        self.dropDownSearch.addSubview(brooklynLabel)
        
        self.dropDownSearch.willRemoveSubview(self.manhattanImageButton)
        self.dropDownSearch.willRemoveSubview(self.manhattanLabel)
        
        self.dropDownSearch.willRemoveSubview(self.bronxImageButton)
        self.dropDownSearch.willRemoveSubview(self.bronxLabel)
        
        self.dropDownSearch.willRemoveSubview(queensImageButton)
        self.dropDownSearch.willRemoveSubview(queensLabel)
        
        self.dropDownSearch.willRemoveSubview(statenIslandImageButton)
        self.dropDownSearch.willRemoveSubview(statenIslandLabel)
        
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseIn, animations: {
            
            self.brooklynImageButton.frame = CGRect(x: 0, y: 0, width: screenWidth + 10, height: 71)
            self.brooklynImageButton.layer.cornerRadius = 0
            self.brooklynLabel.frame = CGRect(x: 0, y: 0, width: screenWidth + 10, height: 71)
            self.brooklynLabel.font = self.brooklynLabel.font.withSize(22)
            
            self.manhattanLabel.frame = CGRect(x: 3, y: 1.5, width: 188, height: 50)
            self.manhattanImageButton.frame = CGRect(x: 3, y: 1.5, width: 188, height: 50)
            self.manhattanLabel.font = self.manhattanLabel.font.withSize(17)
            self.manhattanImageButton.layer.cornerRadius = 14
            
            self.scrollViewForBoroughs.frame = CGRect(x: 500, y: 71, width: screenWidth + 10, height: 53)
            
            self.queensImageButton.frame = CGRect(x: 196, y: Int(1.5), width: 188, height: 50)
            self.queensLabel.frame = CGRect(x: 196, y: Int(1.5), width: 188, height: 50)
            self.queensLabel.font = self.queensLabel.font.withSize(17)
            self.queensImageButton.layer.cornerRadius = 14
            
            self.bronxImageButton.frame = CGRect(x: 389, y: Int(1.5), width: 188, height: 50)
            self.bronxLabel.frame = CGRect(x: 389, y: Int(1.5), width: 188, height: 50)
            self.bronxLabel.font = self.bronxLabel.font.withSize(17)
            self.bronxImageButton.layer.cornerRadius = 14
            
            self.statenIslandImageButton.frame = CGRect(x: 582, y: Int(1.5), width: 188, height: 50)
            self.statenIslandLabel.frame = CGRect(x: 582, y: Int(1.5), width: 188, height: 50)
            self.statenIslandLabel.font = self.statenIslandLabel.font.withSize(17)
            self.statenIslandImageButton.layer.cornerRadius = 14
            self.dropDownSearch.addSubview(self.closePhotos)
            self.scrollViewForBoroughs.contentSize.width = 779
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.searchAroundMe.isHidden = false
                self.searchAroundMe.frame = CGRect(x: 5, y: 75, width: screenWidth, height: 48)
            }, completion: nil)
            

            print("The location of the label", self.manhattanLabel.font)
        }, completion: nil)

    }
    func queensFunc(){
        let screenWidth = self.view.frame.width
        cancelButton.isHidden = true
        closePhotos.isHidden = false
        viewTemp.isHidden = true
        searchController.searchBar.isHidden = true
        self.searchController.isActive = true
        self.searchController.searchBar.text = "Queens";
        
        
        
        self.dropDownSearch.willRemoveSubview(viewTemp)
        
        self.dropDownSearch.willRemoveSubview(manhattanImageButton)
        self.dropDownSearch.willRemoveSubview(manhattanLabel)
        
        self.dropDownSearch.willRemoveSubview(brooklynImageButton)
        self.dropDownSearch.willRemoveSubview(brooklynLabel)
        
        self.dropDownSearch.willRemoveSubview(bronxImageButton)
        self.dropDownSearch.willRemoveSubview(bronxLabel)
        
        self.dropDownSearch.willRemoveSubview(statenIslandImageButton)
        self.dropDownSearch.willRemoveSubview(statenIslandLabel)
        
        self.scrollViewForBoroughs.willRemoveSubview(queensImageButton)
        self.scrollViewForBoroughs.willRemoveSubview(queensLabel)
        
        self.scrollViewForBoroughs.addSubview(manhattanImageButton)
        self.scrollViewForBoroughs.addSubview(manhattanLabel)
        
        self.scrollViewForBoroughs.addSubview(brooklynImageButton)
        self.scrollViewForBoroughs.addSubview(brooklynLabel)
        
        self.scrollViewForBoroughs.addSubview(bronxImageButton)
        self.scrollViewForBoroughs.addSubview(bronxLabel)
        
        self.scrollViewForBoroughs.addSubview(statenIslandImageButton)
        self.scrollViewForBoroughs.addSubview(statenIslandLabel)
        
        self.dropDownSearch.addSubview(queensImageButton)
        self.dropDownSearch.addSubview(queensLabel)
        
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseIn, animations: {
        
            self.queensImageButton.frame = CGRect(x: 0, y: 0, width: screenWidth + 10, height: 71)
            self.queensImageButton.layer.cornerRadius = 0
            self.queensLabel.frame = CGRect(x: 0, y: 0, width: screenWidth + 10, height: 71)
            self.queensLabel.font = self.queensLabel.font.withSize(22)
            
            self.manhattanLabel.frame = CGRect(x: 3, y: 1.5, width: 188, height: 50)
            self.manhattanImageButton.frame = CGRect(x: 3, y: 1.5, width: 188, height: 50)
            self.manhattanLabel.font = self.manhattanLabel.font.withSize(17)
            self.manhattanImageButton.layer.cornerRadius = 14

            self.scrollViewForBoroughs.frame = CGRect(x: 500, y: 71, width: screenWidth + 10, height: 53)
            
            self.brooklynImageButton.frame = CGRect(x: 196, y: Int(1.5), width: 188, height: 50)
            self.brooklynLabel.frame = CGRect(x: 196, y: Int(1.5), width: 188, height: 50)
            self.brooklynLabel.font = self.queensLabel.font.withSize(17)
            self.brooklynImageButton.layer.cornerRadius = 14
            
            self.bronxImageButton.frame = CGRect(x: 389, y: Int(1.5), width: 188, height: 50)
            self.bronxLabel.frame = CGRect(x: 389, y: Int(1.5), width: 188, height: 50)
            self.bronxLabel.font = self.bronxLabel.font.withSize(17)
            self.bronxImageButton.layer.cornerRadius = 14

            self.statenIslandImageButton.frame = CGRect(x: 582, y: Int(1.5), width: 188, height: 50)
            self.statenIslandLabel.frame = CGRect(x: 582, y: Int(1.5), width: 188, height: 50)
            self.statenIslandLabel.font = self.statenIslandLabel.font.withSize(17)
            self.statenIslandImageButton.layer.cornerRadius = 14
            self.dropDownSearch.addSubview(self.closePhotos)
            self.scrollViewForBoroughs.contentSize.width = 779
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.searchAroundMe.isHidden = false
                self.searchAroundMe.frame = CGRect(x: 5, y: 75, width: screenWidth, height: 48)
            }, completion: nil)
            

        
        }, completion: nil)
         print("ALL good here")
    }
    func bronxFunc(){
        let screenWidth = self.view.frame.width
        cancelButton.isHidden = true
        closePhotos.isHidden = false
        viewTemp.isHidden = true
        searchController.searchBar.isHidden = true
        self.searchController.isActive = true
        self.searchController.searchBar.text = "Bronx";
        
        
        self.scrollViewForBoroughs.willRemoveSubview(viewTemp)
        
        self.scrollViewForBoroughs.willRemoveSubview(bronxImageButton)
        self.scrollViewForBoroughs.willRemoveSubview(bronxLabel)
        
        self.scrollViewForBoroughs.addSubview(manhattanImageButton)
        self.scrollViewForBoroughs.addSubview(manhattanLabel)
        
        self.scrollViewForBoroughs.addSubview(queensImageButton)
        self.scrollViewForBoroughs.addSubview(queensLabel)

        self.scrollViewForBoroughs.addSubview(brooklynImageButton)
        self.scrollViewForBoroughs.addSubview(brooklynLabel)
        
        self.scrollViewForBoroughs.addSubview(statenIslandImageButton)
        self.scrollViewForBoroughs.addSubview(statenIslandLabel)

        self.dropDownSearch.addSubview(bronxImageButton)
        self.dropDownSearch.addSubview(bronxLabel)
        
        self.dropDownSearch.willRemoveSubview(self.manhattanImageButton)
        self.dropDownSearch.willRemoveSubview(self.manhattanLabel)
        
        self.dropDownSearch.willRemoveSubview(self.brooklynImageButton)
        self.dropDownSearch.willRemoveSubview(self.brooklynLabel)
        
        self.dropDownSearch.willRemoveSubview(queensImageButton)
        self.dropDownSearch.willRemoveSubview(queensLabel)
        
        self.dropDownSearch.willRemoveSubview(statenIslandImageButton)
        self.dropDownSearch.willRemoveSubview(statenIslandLabel)
        
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseIn, animations: {
            
            self.bronxImageButton.frame = CGRect(x: 0, y: 0, width: screenWidth + 10, height: 71)
            self.bronxImageButton.layer.cornerRadius = 0
            self.bronxLabel.frame = CGRect(x: 0, y: 0, width: screenWidth + 10, height: 71)
            self.bronxLabel.font = self.brooklynLabel.font.withSize(22)
            
            self.manhattanLabel.frame = CGRect(x: 3, y: 1.5, width: 188, height: 50)
            self.manhattanImageButton.frame = CGRect(x: 3, y: 1.5, width: 188, height: 50)
            self.manhattanLabel.font = self.manhattanLabel.font.withSize(17)
            self.manhattanImageButton.layer.cornerRadius = 14

            self.scrollViewForBoroughs.frame = CGRect(x: 500, y: 71, width: screenWidth + 10, height: 53)
            
            self.queensImageButton.frame = CGRect(x: 389, y: Int(1.5), width: 188, height: 50)
            self.queensLabel.frame = CGRect(x: 389, y: Int(1.5), width: 188, height: 50)
            self.queensLabel.font = self.queensLabel.font.withSize(17)
            self.queensImageButton.layer.cornerRadius = 14
            
            self.brooklynImageButton.frame = CGRect(x: 196, y: Int(1.5), width: 188, height: 50)
            self.brooklynLabel.frame = CGRect(x: 196, y: Int(1.5), width: 188, height: 50)
            self.brooklynLabel.font = self.bronxLabel.font.withSize(17)
            self.brooklynImageButton.layer.cornerRadius = 14
            
            self.statenIslandImageButton.frame = CGRect(x: 582, y: Int(1.5), width: 188, height: 50)
            self.statenIslandLabel.frame = CGRect(x: 582, y: Int(1.5), width: 188, height: 50)
            self.statenIslandLabel.font = self.statenIslandLabel.font.withSize(17)
            self.statenIslandImageButton.layer.cornerRadius = 14
            
            self.scrollViewForBoroughs.contentSize.width = 779
            self.dropDownSearch.addSubview(self.closePhotos)
            
            }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.searchAroundMe.isHidden = false
            self.searchAroundMe.frame = CGRect(x: 5, y: 75, width: screenWidth, height: 48)
        }, completion: nil)
        

         print("ALL good here")
    }
    func statenIslandFunc(){
        let screenWidth = self.view.frame.width
        cancelButton.isHidden = true
        closePhotos.isHidden = false
        viewTemp.isHidden = true
        searchController.searchBar.isHidden = true
        self.searchController.isActive = true
        self.searchController.searchBar.text = "Staten Island";
        
        self.scrollViewForBoroughs.willRemoveSubview(statenIslandImageButton)
        self.scrollViewForBoroughs.willRemoveSubview(statenIslandLabel)
        
        self.scrollViewForBoroughs.addSubview(manhattanImageButton)
        self.scrollViewForBoroughs.addSubview(manhattanLabel)
        
        self.scrollViewForBoroughs.addSubview(queensImageButton)
        self.scrollViewForBoroughs.addSubview(queensLabel)
        
        self.scrollViewForBoroughs.addSubview(brooklynImageButton)
        self.scrollViewForBoroughs.addSubview(brooklynLabel)
        
        self.scrollViewForBoroughs.addSubview(bronxImageButton)
        self.scrollViewForBoroughs.addSubview(bronxLabel)
        
        self.dropDownSearch.willRemoveSubview(self.manhattanImageButton)
        self.dropDownSearch.willRemoveSubview(self.manhattanLabel)
        
        self.dropDownSearch.willRemoveSubview(self.bronxImageButton)
        self.dropDownSearch.willRemoveSubview(self.bronxLabel)
        
        self.dropDownSearch.willRemoveSubview(queensImageButton)
        self.dropDownSearch.willRemoveSubview(queensLabel)

        self.dropDownSearch.willRemoveSubview(bronxImageButton)
        self.dropDownSearch.willRemoveSubview(bronxLabel)
        
        self.dropDownSearch.addSubview(statenIslandImageButton)
        self.dropDownSearch.addSubview(statenIslandLabel)

UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseIn, animations: {
    self.statenIslandImageButton.frame = CGRect(x: 0, y: 0, width: screenWidth + 10, height: 71)
    self.statenIslandImageButton.layer.cornerRadius = 0
    self.statenIslandLabel.frame = CGRect(x: 0, y: 0, width: screenWidth + 10, height: 71)
    self.statenIslandLabel.font = self.brooklynLabel.font.withSize(22)

    self.manhattanLabel.frame = CGRect(x: 3, y: 1.5, width: 188, height: 50)
    self.manhattanImageButton.frame = CGRect(x: 3, y: 1.5, width: 188, height: 50)
    self.manhattanLabel.font = self.manhattanLabel.font.withSize(17)
    self.manhattanImageButton.layer.cornerRadius = 14
    
    self.scrollViewForBoroughs.frame = CGRect(x: 500, y: 71, width: screenWidth + 10, height: 53)
    
    self.brooklynImageButton.frame = CGRect(x: 196, y: Int(1.5), width: 188, height: 50)
    self.brooklynLabel.frame = CGRect(x: 196, y: Int(1.5), width: 188, height: 50)
    self.brooklynLabel.font = self.queensLabel.font.withSize(17)
    self.brooklynImageButton.layer.cornerRadius = 14
    
    self.queensImageButton.frame = CGRect(x: 389, y: Int(1.5), width: 188, height: 50)
    self.queensLabel.frame = CGRect(x: 389, y: Int(1.5), width: 188, height: 50)
    self.queensLabel.font = self.bronxLabel.font.withSize(17)
    self.queensImageButton.layer.cornerRadius = 14
    
    self.bronxImageButton.frame = CGRect(x: 582, y: Int(1.5), width: 188, height: 50)
    self.bronxLabel.frame = CGRect(x: 582, y: Int(1.5), width: 188, height: 50)
    self.bronxLabel.font = self.bronxLabel.font.withSize(17)
    self.bronxImageButton.layer.cornerRadius = 14
    self.dropDownSearch.addSubview(self.closePhotos)

    self.scrollViewForBoroughs.contentSize.width = 779
    
}, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.searchAroundMe.isHidden = false
            self.searchAroundMe.frame = CGRect(x: 5, y: 75, width: screenWidth, height: 48)
        }, completion: nil)
        


         print("ALL good here")
    }
    func resetImages(){
        let screenWidth = self.view.frame.width
        
        cancelButton.isHidden = false
        closePhotos.isHidden = true
        viewTemp.isHidden = false
        searchController.searchBar.isHidden = false
        self.searchController.isActive = true
        self.searchController.searchBar.text = "";
        
        
        
        self.dropDownSearch.addSubview(cancelButton)
        self.dropDownSearch.willRemoveSubview(self.manhattanImageButton)
        self.dropDownSearch.willRemoveSubview(self.manhattanLabel)
        
        self.dropDownSearch.willRemoveSubview(self.brooklynImageButton)
        self.dropDownSearch.willRemoveSubview(self.brooklynLabel)
        
        self.dropDownSearch.willRemoveSubview(queensImageButton)
        self.dropDownSearch.willRemoveSubview(queensLabel)
        
        self.dropDownSearch.willRemoveSubview(statenIslandImageButton)
        self.dropDownSearch.willRemoveSubview(statenIslandLabel)
        
        self.dropDownSearch.willRemoveSubview(bronxImageButton)
        self.dropDownSearch.willRemoveSubview(bronxLabel)
        
        self.scrollViewForBoroughs.addSubview(manhattanImageButton)
        self.scrollViewForBoroughs.addSubview(manhattanLabel)
        
        self.scrollViewForBoroughs.addSubview(queensImageButton)
        self.scrollViewForBoroughs.addSubview(queensLabel)
        
        self.scrollViewForBoroughs.addSubview(brooklynImageButton)
        self.scrollViewForBoroughs.addSubview(brooklynLabel)
        
        self.scrollViewForBoroughs.addSubview(statenIslandImageButton)
        self.scrollViewForBoroughs.addSubview(statenIslandLabel)
        
        self.scrollViewForBoroughs.addSubview(bronxImageButton)
        self.scrollViewForBoroughs.addSubview(bronxLabel)
        
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseIn, animations: {
        
            self.scrollViewForBoroughs.frame = CGRect(x: 0, y: 71, width: screenWidth + 10, height: 53)
        
            self.manhattanLabel.frame = CGRect(x: 3, y: 1.5, width: 188, height: 50)
            self.manhattanImageButton.frame = CGRect(x: 3, y: 1.5, width: 188, height: 50)
            self.manhattanLabel.font = self.manhattanLabel.font.withSize(17)
            self.manhattanImageButton.layer.cornerRadius = 14
            
            self.brooklynImageButton.frame = CGRect(x: 196, y: Int(1.5), width: 188, height: 50)
            self.brooklynLabel.frame = CGRect(x: 196, y: Int(1.5), width: 188, height: 50)
            self.brooklynLabel.font = self.queensLabel.font.withSize(17)
            self.brooklynImageButton.layer.cornerRadius = 14
            
            self.queensImageButton.frame = CGRect(x: 389, y: Int(1.5), width: 188, height: 50)
            self.queensLabel.frame = CGRect(x: 389, y: Int(1.5), width: 188, height: 50)
            self.queensLabel.font = self.bronxLabel.font.withSize(17)
            self.queensImageButton.layer.cornerRadius = 14
            
            self.bronxImageButton.frame = CGRect(x: 582, y: Int(1.5), width: 188, height: 50)
            self.bronxLabel.frame = CGRect(x: 582, y: Int(1.5), width: 188, height: 50)
            self.bronxLabel.font = self.bronxLabel.font.withSize(17)
            self.bronxImageButton.layer.cornerRadius = 14
            
            
            self.statenIslandImageButton.frame = CGRect(x: 775, y: Int(1.5), width: 188, height: 50)
            self.statenIslandLabel.frame = CGRect(x: 775, y: Int(1.5), width: 188, height: 50)
            self.statenIslandLabel.font = self.statenIslandLabel.font.withSize(17)
            self.statenIslandImageButton.layer.cornerRadius = 14

            self.scrollViewForBoroughs.contentSize.width = 972
            
            self.dropDownSearch.addSubview(self.viewTemp)
            self.dropDownSearch.addSubview(self.viewTemp)
            self.dropDownSearch.willRemoveSubview(self.closePhotos)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                
                //self.searchAroundMe.frame = CGRect(x: 500, y: 75, width: screenWidth, height: 48)
                self.searchAroundMe.isHidden = false
                self.searchAroundMe.frame = self.originalSearchBarLocation!
            }, completion: nil)
            

        }, completion: nil)

    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let candies = locations
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredCandies.count
        }
        return candies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let candies = locations
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let candy: mapPoints
        if searchController.isActive && searchController.searchBar.text != ""{
            candy = filteredCandies[indexPath.row]
        } else{
        candy = candies[indexPath.row]
        }
        cell.textLabel?.text = candy.Borough
        cell.detailTextLabel?.text = candy.Neighborhood
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showNewYorkUsers", sender: self)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        let candies = locations
        filteredCandies = candies.filter { candy in
            let categoryMatch = candy.Borough.lowercased().contains(searchText.lowercased())
            return categoryMatch || candy.Neighborhood.lowercased().contains(searchText.lowercased())
            
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("the amount in this section here", filteredLocations.count)
        return filteredLocations.count
    }
 //169
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {//345 214
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! cellForLocations
        cell.backgroundColor = UIColor.clear
        
       
        let locationInformation = filteredLocations[indexPath.row]
        cell.boroughLabel.text = locationInformation.Neighborhood
        cell.upperLabel.text = locationInformation.Borough
        cell.clearResults.addTarget(self, action: #selector(removePointsAndMoveCollectionView), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "collectionViewSegue", sender: self)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if filteredLocations.count == 0 {
            print("nothing here")
        } else{
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = (collectionView.indexPathForItem(at: visiblePoint))!
     
        let filteredLocationMapPoints = filteredLocations[(visibleIndexPath.item)]
        
        let filteredLocationLat = filteredLocationMapPoints.latitude
        let filteredLocationLong = filteredLocationMapPoints.longitude
        let combinedFilteredPoints = CLLocationCoordinate2D(latitude: filteredLocationLat, longitude: filteredLocationLong)
            
        
        mapView.setCenter(combinedFilteredPoints, zoomLevel: 14, animated: true)
    }
           }
    
    func privacyAlertAnimateIn(){
        self.view.addSubview(privacyAlert)
   
        privacyAlert.center = self.view.center
        privacyAlert.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        privacyAlert.alpha = 0
        
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.privacyAlert.alpha = 1
            self.privacyAlert.transform = CGAffineTransform.identity
        }
    }
    func privacyAlertAnimateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.privacyAlert.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.privacyAlert.alpha = 0
            self.visualEffectView.effect = nil
        }) {(success:Bool) in
                self.privacyAlert.removeFromSuperview()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewYorkUsers" {
            let candies = locations
            let indexPath = tableView.indexPathForSelectedRow
            let navigationVC = segue.destination as? UINavigationController
            let viewController = navigationVC?.viewControllers.first as! viewControllerForUser
            let candy: mapPoints
            if searchController.isActive && searchController.searchBar.text != "" {
                candy = filteredCandies[(indexPath?.row)!]
                let userArray = [(String(candy.Borough)),", ",(String(candy.Neighborhood))]
                viewController.neighboorHood = candy.Neighborhood
                viewController.locationToPass = userArray.joined(separator: "")
            } else{
                candy = candies[(indexPath?.row)!]
                let userArray = [(String(candy.Borough)),", ",(String(candy.Neighborhood))]
                viewController.neighboorHood = candy.Neighborhood
                viewController.locationToPass = userArray.joined(separator: "")
            }
    }
        if segue.identifier == "collectionViewSegue" {
        let indexPath = collectionView.indexPathsForSelectedItems?.last
        let navigationVC = segue.destination as? UINavigationController
        let viewController = navigationVC?.viewControllers.first as! viewControllerForUser
           let filteredLocationToPass = filteredLocations[(indexPath?.item)!]
           let userArray = [(String(filteredLocationToPass.Borough)),", ",(String(filteredLocationToPass.Neighborhood))]
            viewController.neighboorHood = filteredLocationToPass.Neighborhood
            viewController.locationToPass = userArray.joined(separator: "")

        }
        if segue.identifier == "annotationViewSegue"{
            let navigationVC = segue.destination as? UINavigationController
            let viewController = navigationVC?.viewControllers.first as! viewControllerForUser
            let theTitle = (sender as! MGLAnnotation).title
            print("", theTitle!!)
            
            let filter = filteredLocations.filter{($0.Neighborhood.contains(theTitle!!))}
            
            filter.map {
                (location) in
                let userArray = [(String(location.Borough)),", ",(String(location.Neighborhood))]
                viewController.neighboorHood = location.Neighborhood
                viewController.locationToPass = userArray.joined(separator:"")
            
            
            }
        }
    
    }   
}
