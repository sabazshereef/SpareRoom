//
//  ViewController.swift
//  SpareRoom_Test
//
//  Created by sabaz shereef on 31/03/21.
//

import UIKit
import SkeletonView
import SDWebImage
import Network

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, SkeletonTableViewDataSource,UITableViewDelegate {
    
    
    let menuBarItemList = ["UPCOMING","ARCHIVED","OPTIONS"]
    var upComingEventsList = [upComingEvents]()
    var upComingEventDetails = [upComingEvents]()
    var upComingEventsListing = [[upComingEvents]]()
    var upComingEventHeader = [Int]()
    
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current
    
    let monthMap = [
        1 : "January",
        2:  "February",
        3:  "March",
        4:  "April",
        5:  "May",
        6:  "June",
        7:  "July",
        8:  "August",
        9:  "September",
        10: "October",
        11: "Novemnber",
        12: "December"
    ]
    
    
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var offlineAndErrorView: UIView!
    @IBOutlet weak var offllineAndErrorViewHeight: NSLayoutConstraint!
    @IBOutlet weak var offlineHeaderText: UILabel!
    @IBOutlet weak var offlineErrorText: UILabel!
    @IBOutlet weak var offlineImage: UIImageView!
    @IBOutlet weak var upComingEventTable: UITableView!
    
    @IBOutlet weak var errorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retryButton.layer.cornerRadius = 5
        offllineAndErrorViewHeight.constant = 0
        
        navigationController?.navigationBar.barTintColor = UIColor(named: "WhiteAndBlack")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let attributes = [NSAttributedString.Key.font: UIFont(name: "SFCompactDisplay-Medium", size: 17)]
        UINavigationBar.appearance().titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        self.checkInternet()
    }
    override func viewDidAppear(_ animated: Bool) {
        upComingEventTable.isSkeletonable = true
        upComingEventTable.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor(named: "SkeltonColor")!), animation: nil, transition: .crossDissolve(0.1))
    }
    //MARK:- Collection View
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuBarCell", for: indexPath) as! MenuBarCell
        if indexPath.item != 0
        {
            cell.menuItemHighlighter.isHidden = true
            cell.menuItem.textColor = UIColor(named: "dusty-grey")
        }
        cell.menuItem.text = menuBarItemList[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: 40)
    }
    
    
    //MARK:- Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return upComingEventsListing.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return monthMap[section + 1]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.tintColor = UIColor(named: "WhiteAndBlack")
        headerView.textLabel?.font = UIFont.init(name: "SFCompactDisplay-Medium", size: 13)
        headerView.textLabel?.textColor = UIColor(named: "dusty-grey")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("indexpath ", upComingEventsListing[section].count)
        return upComingEventsListing[section].count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "EventListCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListCell") as! EventListCell
        
        cell.skeltonCamera.isHidden = true
        cell.eventVenue.text = upComingEventsListing[indexPath.section][indexPath.row].venue
        cell.eventLocation.text = upComingEventsListing[indexPath.section][indexPath.row].location
        if let imageUrl = upComingEventsListing[indexPath.section][indexPath.row].imageURL {
            cell.eventImage.sd_setImage(with: URL(string: imageUrl), completed: nil)
            
        }
        let startTime = upComingEventsListing[indexPath.section][indexPath.row].startTime
        let dateFormatedStartTime = dateFormating(date: startTime ?? "")
        let startEventTime = dateFormatedStartTime.dateConverter(date: dateFormatedStartTime, pass: 1)
        let endTime = upComingEventsListing[indexPath.section][indexPath.row].endTime
        let dateFormatedEndTime = dateFormating(date: endTime ?? "")
        let EndEventTime = dateFormatedEndTime.dateConverter(date: dateFormatedEndTime, pass: 0)
        cell.eventTime.text = "\(startEventTime)-\(EndEventTime)"
        cell.eventDate.text = dateFormatedStartTime.dateConverter(date: dateFormatedStartTime, pass: 4)
        cell.eventCost.text = upComingEventsListing[indexPath.section][indexPath.row].cost
        
        
        return cell
    }
    
// MARK:- Checking if the phone have a internet connection
    func checkInternet() {
        
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.fetchUpComingApi()
            } else {
                DispatchQueue.main.async {
                    
                    self.setupErrorView(imageName: "OfflineIcon", headerString: "No Connection", errorText: "You appear to be offline. Check your mobile or wifi connection and try again")
                }
            }
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
    
//MARK:- Taking data from server
   
    func fetchUpComingApi()   {
        
        let dataLoader = eventApiLoader()
        dataLoader.fetchingForUpcomingEvents { [weak self] success in
            
            switch success{
            case .failure( _):
                self?.setupErrorView(imageName: "ErrorIcon", headerString: "Something's gone wrong", errorText: "We couldn't load the upcoming events. Check your cellular or wificonnection and try again ")
                
            case .success(let success):
                if success.count == 0 {
                    self?.retryButton.isHidden = true
                    self?.setupErrorView(imageName: "ListIcon", headerString: "Nothing to show", errorText: "No upcoming events are scheduled. If this is incorrect, get in touch with our CORE team")
                }
                else {
                    self?.upComingEventsList = success
                    self?.grouping()
                    
                    DispatchQueue.main.async {
                        self?.upComingEventTable.reloadData()
                        self?.upComingEventTable.stopSkeletonAnimation()
                        self?.view.hideSkeleton()
                    }
                }
            }
        }
    }
//MARK: - Date formater
    fileprivate func dateFormating(date : String) -> Date{
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return  dateFormatter.date(from: date) ?? Date()
    }
 //MARK: - Grouping Data based on month
   
    fileprivate func grouping() {
        
        let keysGrouping = Dictionary(grouping: upComingEventsList) { (dateList) -> Int in
            let dateformat = dateFormating(date: dateList.startTime ?? "")
            let comp = calendar.dateComponents([.year, .month], from: dateformat).month
            
            return comp ?? 0
        }
        
        keysGrouping.keys.sorted().forEach { (key) in
            guard let values = keysGrouping[key] else { return }
            upComingEventsListing.append(values)
        }
    }
    
//MARK:- Error view for different types of errors
   
    func setupErrorView(imageName: String, headerString: String, errorText: String) {
        
        self.offllineAndErrorViewHeight.constant = (self.view.frame.size.height) * 40/100
        self.offlineImage.image = UIImage(named: imageName)
        self.offlineHeaderText.text = headerString
        self.offlineErrorText.text = errorText
    }
    
    @IBAction func retryAction(_ sender: Any) {
        checkInternet()
    }
}

