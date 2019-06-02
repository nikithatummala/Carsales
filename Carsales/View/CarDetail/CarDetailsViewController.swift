//
//  CarDetailsViewController.swift
//  Carsales
//
//  Created by Nikitha Paruchuri on 1/6/19.
//  Copyright © 2019 Nikitha T. All rights reserved.
//

import UIKit

class CarDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    private var errorLabel : UILabel!
    
    // The images url and car name is set when this controller is pushed on to the stack from CarsListViewController
    var carDetailsUrl:String = ""
    var carName = ""
    
    private let carDetailsViewModel = CarDetailsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        initNavBarTitle()
        addObservers()
        configureNetworkErrorLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    /**
     Displays title in navigation bar with a center aligned label supporting multiple lines
     **/
    func initNavBarTitle() {
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.font =  UIFont.systemFont(ofSize:Helper.shared.isIpad ? 20 : 16)
        label.textAlignment = .center
        label.textColor = Helper.shared.themeColor
        label.text = carName
        self.navigationItem.titleView = label
    }
    
    //MARK: - Observers Setup
    
    func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: .didNetworkStatusChange, object: nil)
    }
    
    func removeObservers() {
        
        NotificationCenter.default.removeObserver(self, name: .didNetworkStatusChange, object: nil)
    }
    
    //MARK: - Network change handling
    
    func configureNetworkErrorLabel() {

        errorLabel = view.viewWithTag(1) as? UILabel
        errorLabel.textColor = Helper.shared.themeColor
        errorLabel.text = Config.internetErrorMsg
        checkNetworkStatusAndShowData()
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        checkNetworkStatusAndShowData()
    }
    
    /** Checks if active network connection exists and shows error text if no internet. Loads data if proper internet connection exists
     **/
    func checkNetworkStatusAndShowData() {
        
        if Helper.shared.isNetworkActive == false {
            tableview.isHidden = true
            errorLabel.isHidden = false
        }
        else {
            tableview.isHidden = false
            errorLabel.isHidden = true
            loadData()
        }
    }
    
    //MARK: - Device rotation 
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        tableview.reloadData()
    }
    
    //MARK: - Fetch data from API
    
    func loadData() {
        
        let url = Config.apiBaseURL + carDetailsUrl + Config.requestCredentials
        carDetailsViewModel.loadData(url) { [weak self] in
            
            self?.tableview.reloadData()
            self?.carDetailsViewModel.loadImages {
                self?.tableview.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            }
        }
    }

}

    // MARK: - UITableViewViewDataSource and UITableViewDelegate

extension CarDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return carDetailsViewModel.numberOfRows
    }
    
    /**
     Returns height for each row, first row displays images and height of row is calculated based on screen width. Fourth row displays overview which is self sizing cell based on content displayed. Other rows default height returned depending on iPhone or iPad device.
     **/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return (UIScreen.main.bounds.width * 2) / 3
        }
        else if indexPath.row == 4 {
            return UITableView.automaticDimension
        }
        return Helper.shared.isIpad ? 50 : 35
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return (UIScreen.main.bounds.width * 2) / 3
        }
        else if indexPath.row == 4 {
            return UITableView.automaticDimension
        }
        return Helper.shared.isIpad ? 50 : 35
    }
    
    /**
     Displays horizontal scrolling images and car details with two different prototype cells from the storyboard
     **/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "photosCell", for: indexPath)
            loadCellWithImages(cell)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath)
        loadCellWithDetails(cell, indexPath: indexPath)
        
        return cell
    }
    
    /**
     Gets the images loaded from server and adds to the scrollview in the cell, allowing horizontal swiping of images
     **/
    func loadCellWithImages(_ cell: UITableViewCell) {
        
        let images = carDetailsViewModel.images
        let loadingIndicator = cell.viewWithTag(2) as! UIActivityIndicatorView
        
        if images.count > 0 {

            loadingIndicator.stopAnimating()

            let scrollView = cell.viewWithTag(1) as! UIScrollView
            
            scrollView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: cell.frame.width,
                                  height: cell.frame.height)
            
            scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(images.count),
                                        height: cell.frame.height)
            
            for i in 0 ..< images.count {
                
                let imageView:UIImageView = UIImageView()
                imageView.image = images[i]
                imageView.frame = CGRect(x: cell.frame.width * CGFloat(i),
                                         y: 0,
                                         width: cell.frame.width,
                                         height: cell.frame.height)
                scrollView.addSubview(imageView)
            }
        }
        else {
            loadingIndicator.startAnimating()
        }
    }
    
    /**
     Loads cells with details received from server like location, price, sale status and overview with font size varying for iPhone and iPad
     **/
    func loadCellWithDetails(_ cell: UITableViewCell, indexPath: IndexPath) {
        
        cell.textLabel?.numberOfLines = 0
        
        var text : String = ""
        var font  = UIFont.boldSystemFont(ofSize: carDetailsViewModel.mediumFontSize)
        var color = Helper.shared.themeColor
        
        switch indexPath.row {
            case 1:
            text = "Location: "
            
            case 2:
            text = "Price: "
            
            case 3:
            text = "Status: "
            
            case 4:
            font = UIFont.systemFont(ofSize: carDetailsViewModel.smallFontSize)
            color = UIColor.black
            
            default:
            break
        }
        
        cell.textLabel?.font = font
        cell.textLabel?.textColor = color
        
        cell.textLabel?.text = text + carDetailsViewModel.carDetails[indexPath.row]
    }
    
}
