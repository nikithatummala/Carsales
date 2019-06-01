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
    
    // The images url and car name is set when this controller is pushed on to the stack from CarsListViewController
    var carDetailsUrl:String = ""
    var carName = ""
    
    private let carDetailsViewModel = CarDetailsViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.tableFooterView = UIView()
        initNavBarTitle()
        loadData()
    }
    
    func initNavBarTitle() {
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.font =  UIFont.systemFont(ofSize:Helper.shared.smallFontSize)
        label.textAlignment = .center
        label.textColor = Helper.shared.themeColor
        label.text = carName
        self.navigationItem.titleView = label
    }

    func loadData() {
        
        let url = Config.apiBaseURL + carDetailsUrl + Config.requestCredentials
        carDetailsViewModel.loadData(url) { [weak self] in
            
            self?.tableview.reloadData()
            self?.carDetailsViewModel.loadImages {
                self?.tableview.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        tableview.reloadData()
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
     **/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "photosCell", for: indexPath)
            loadCellWithImages(cell)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        
        var text : String = ""
        var font  = UIFont.boldSystemFont(ofSize: Helper.shared.mediumFontSize)
        var color = Helper.shared.themeColor
        
        switch indexPath.row {
            case 1:
            text = "Location: "
            
            case 2:
            text = "Price: "
            
            case 3:
            text = "Status: "
            
            case 4:
            font = UIFont.systemFont(ofSize: Helper.shared.smallFontSize)
            color = UIColor.black
            
            default:
            break
        }
        
        cell.textLabel?.font = font
        cell.textLabel?.textColor = color
        
        cell.textLabel?.text = text + carDetailsViewModel.carDetails[indexPath.row]
        
        return cell
    }
    
    
    func loadCellWithImages(_ cell: UITableViewCell) {
        
        let images = carDetailsViewModel.images
        
        if images.count > 0 {
            
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
    }
    
}