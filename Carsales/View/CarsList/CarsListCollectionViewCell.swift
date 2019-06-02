//
//  CarsListCollectionViewCell.swift
//  Carsales
//
//  Created by Nikitha Paruchuri on 31/5/19.
//  Copyright © 2019 Nikitha T. All rights reserved.
//

import UIKit

class CarsListCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var carImageHeightConstraint: NSLayoutConstraint!
    
    var carModel : CarsList!
    
    var imageHandler : ImageHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /**
     Initializes the car Model and image handler, and calls UI display funcitons
     **/
    func configure(with carModel: CarsList, collectionview: UICollectionView) {
        
        self.carModel = carModel
        self.imageHandler = ImageHandler(Config.imageFolderName)

        setUI()
        resetImage(collectionview: collectionview)
        loadImage()
    }
    
    /**
     Populates labels in the cell with the car Model data
     **/
    func setUI() {
        
        nameLabel.text = carModel.title
        priceLabel.text = carModel.price
        locationLabel.text = carModel.location
        
        priceLabel.textColor = Helper.shared.themeColor
    }
    
    /**
     Reset image height based on 3:2 ratio of device width
     **/
    func resetImage(collectionview: UICollectionView) {
        carImage.image = nil
        let size = Helper.shared.getSizeForItems(collectionview)
        carImageHeightConstraint.constant = size.height - CGFloat(Config.collectionViewCellSpacing)
    }
    
    func loadImage() {
        
        loadingIndicator.startAnimating()

        imageHandler?.getImage(carModel.mainPhoto) { image in
            self.loadingIndicator.stopAnimating()
            self.carImage.image = image
        }
    }
    
}
