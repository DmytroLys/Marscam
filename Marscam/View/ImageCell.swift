//
//  ImageCell.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 21.09.2023.
//

import UIKit

class ImageCell: UITableViewCell {
    
   @IBOutlet private weak var imageBubble: UIView!
   @IBOutlet private weak var roverNameLabel: UILabel!
   @IBOutlet private weak var cameraTypeLabel: UILabel!
   @IBOutlet private weak var dateLabel: UILabel!
   @IBOutlet private weak var imageName: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageBubble.layer.cornerRadius = 20
        selectionStyle = .none
        
        imageBubble.layer.masksToBounds = false
        imageBubble.layer.shadowRadius = 5.0
        imageBubble.layer.shadowOpacity = 0.30
        imageBubble.layer.shadowColor = UIColor(named: "layerTwo")?.cgColor
        imageBubble.layer.shadowOffset = CGSize(width: 0, height: 5)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setRoverName(name: String) {
        let roverAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor(named: "layerTwo")?.cgColor ?? UIColor.gray
        ]
        
        let nameAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor(named: "layerOne")?.cgColor ?? UIColor.black
        ]

        let attributedString = NSMutableAttributedString(string: "Rover: ", attributes: roverAttributes)
        
        attributedString.append(NSAttributedString(string: name, attributes: nameAttributes))
        
        roverNameLabel.attributedText = attributedString
    }
    
    func setCameraTypeLabel(type: String) {
        let cameraAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor(named: "layerTwo")?.cgColor ?? UIColor.gray
        ]
        
        let typeAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor(named: "layerOne")?.cgColor ?? UIColor.black
        ]
        
        let attributedString = NSMutableAttributedString(string: "Camera: ", attributes: cameraAttributes)
        
        attributedString.append(NSAttributedString(string: type, attributes: typeAttributes))
        
        cameraTypeLabel.attributedText = attributedString
    }
    
    func setDateLabel(date: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor(named: "layerTwo")?.cgColor ?? UIColor.gray
        ]
        
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor(named: "layerOne")?.cgColor ?? UIColor.black
        ]
        
        let attributedString = NSMutableAttributedString(string: "Date: ", attributes: attributes)
        
        attributedString.append(NSAttributedString(string: date, attributes: dateAttributes))
        
        dateLabel.attributedText = attributedString
    }
    
    
}
