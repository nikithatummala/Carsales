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
    
    var carModel : CarsList!
    
    var imageHandler : ImageHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with carModel: CarsList) {
        
        self.carModel = carModel
        self.imageHandler = ImageHandler(Config.imageFolderName)

        setUI()
        resetImage()
        loadImage()
    }
    
    func setUI() {
        
        nameLabel.text = carModel.title
        priceLabel.text = carModel.price
        locationLabel.text = carModel.location
        
        priceLabel.textColor = Helper.shared.themeColor
    }
    
    func resetImage() {
        carImage.image = nil
    }
    
    func loadImage() {
        
        loadingIndicator.startAnimating()

        imageHandler?.getImage(carModel.mainPhoto) { image in
            self.loadingIndicator.stopAnimating()
            self.carImage.image = image
        }
    }
    
}
