//
//  ImageCell.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 21.09.2023.
//

import UIKit

class ImageCell: UITableViewCell {
    
   @IBOutlet private weak var cellBubble: UIView!
   @IBOutlet private weak var roverNameLabel: UILabel!
   @IBOutlet private weak var cameraTypeLabel: UILabel!
   @IBOutlet private weak var dateLabel: UILabel!
   @IBOutlet private weak var photo: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBubble.layer.cornerRadius = 20
        selectionStyle = .none
        
        cellBubble.layer.masksToBounds = false
        cellBubble.layer.shadowRadius = 5.0
        cellBubble.layer.shadowOpacity = 0.30
        cellBubble.layer.shadowColor = UIColor(named: "layerTwo")?.cgColor
        cellBubble.layer.shadowOffset = CGSize(width: 0, height: 5)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setRoverName(name: String) {
        
        roverNameLabel.attributedText = returnAttributedStringWithTitle(with: "Rover:  ", type: name)
    }
    
    func setCameraTypeLabel(type: String) {
        
        cameraTypeLabel.attributedText = returnAttributedStringWithTitle(with: "Camera:  ", type: type)
    }
    
    func setDateLabel(date: String) {
        
        dateLabel.attributedText = returnAttributedStringWithTitle(with: "Date:  ", type: date)
    }
    
    func setImageView(url:URL) {
        photo.kf.setImage(with: url)
    }
    
    private func returnAttributedStringWithTitle(with title: String, type: String) -> NSMutableAttributedString {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor(named: "layerTwo")?.cgColor ?? UIColor.gray
        ]
        
        let typeAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor(named: "layerOne")?.cgColor ?? UIColor.black
        ]
        
        let attributedString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        
        attributedString.append(NSAttributedString(string: type, attributes: typeAttributes))
        
        return attributedString
    }
    
    
}
