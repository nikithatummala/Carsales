//
//  CarsListViewController.swift
//  Carsales
//
//  Created by Nikitha Paruchuri on 31/5/19.
//  Copyright © 2019 Nikitha T. All rights reserved.
//

import UIKit

class CarsListViewController: UICollectionViewController {
    
    private let carListCellIdentifier = "carsListCell"
    private let carListXibIdentifier = "CarsListCollectionViewCell"
 
    private let viewModel: CarsListViewModel = CarsListViewModel()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initNavigationBar()
        registerCollectionViewCells()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationItem.title = Config.appTitle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    func initNavigationBar() {
        
        navigationController?.navigationBar.tintColor = Helper.shared.themeColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Helper.shared.themeColor]
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

extension CarsListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return viewModel.getSizeForItems(self.collectionView)
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
        
        cell.configure(with: viewModel.carList[indexPath.row])
        
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
