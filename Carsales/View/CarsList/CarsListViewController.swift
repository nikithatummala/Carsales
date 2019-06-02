//
//  CarsListViewController.swift
//  Carsales
//
//  Created by Nikitha Paruchuri on 31/5/19.
//  Copyright © 2019 Nikitha T. All rights reserved.
//

import UIKit

class CarsListViewController: UICollectionViewController {
    
    private var errorLabel : UILabel!

    private let carListCellIdentifier = "carsListCell"
    private let carListXibIdentifier = "CarsListCollectionViewCell"
 
    private let viewModel: CarsListViewModel = CarsListViewModel()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initNavigationBar()
        registerCollectionViewCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        
        navigationItem.title = Config.appTitle
        
        addObservers()
        configureNetworkErrorLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        navigationItem.title = ""
        removeObservers()
    }
    
    func initNavigationBar() {
        
        navigationController?.navigationBar.tintColor = Helper.shared.themeColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Helper.shared.themeColor, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
    }
    
    //MARK: - Observers Setup

    func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(networkStatusChanged(_:)),
                                               name: .didNetworkStatusChange,
                                               object: nil)
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
    
        if Helper.shared.isNetworkActive == false  {
            errorLabel.isHidden = false
            viewModel.carList.removeAll()
            collectionView.reloadData()
        }
        else {
            errorLabel.isHidden = true
            loadData()
        }
    }
    
    //MARK: - Collection View Setup
    
    func registerCollectionViewCells() {
        
        let nib = UINib(nibName: carListXibIdentifier, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: carListCellIdentifier)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    //MARK: - Fetch data from API

    func loadData() {
        
        let url = Config.apiBaseURL + Config.listingURI + Config.requestCredentials
        
        viewModel.loadData(url) { [weak self] in
            self?.collectionView.reloadData()
        }
    }

}

    // MARK: - UICollectionViewDelegateFlowLayout

extension CarsListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return Helper.shared.getSizeForItems(self.collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: 25)
    }
   
}

    // MARK: - UICollectionViewDataSource

extension CarsListViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: carListCellIdentifier, for: indexPath) as! CarsListCollectionViewCell
        
        cell.configure(with: viewModel.carList[indexPath.row], collectionview: collectionView)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "carDetails") as? CarDetailsViewController {
            
            vc.carDetailsUrl = viewModel.carList[indexPath.row].detailsUrl
            vc.carName = viewModel.carList[indexPath.row].title
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
