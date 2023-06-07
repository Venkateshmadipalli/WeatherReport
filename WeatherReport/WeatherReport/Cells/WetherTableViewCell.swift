//
//  WetherTableViewCell.swift
//  WetherConditionApp
//
//  
//

import UIKit

class WetherTableViewCell: UITableViewCell {
    
    
    static let identifier = "WetherTableViewCell"
    let forcastIcon = UIImageView()
    let currentWeather = UILabel()
    let minAndMaxLable = UILabel()
    let currentDate = UILabel()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        forcastIcon.frame = CGRect(
            x: 10, y: Int(10), width: Int(20), height: 20)
        
        currentWeather.frame = CGRect(
            x: 40, y: Int(10), width: Int(contentView.bounds.width - 20),
            height: 20)
        minAndMaxLable.frame = CGRect(
            x: 10, y: Int(50), width: Int(contentView.bounds.width - 20),
            height: 20)
        currentDate.frame = CGRect(
            x: 10, y: Int(80), width: Int(contentView.bounds.width - 20),
            height: 20)
        
        contentView.addSubview(forcastIcon)
        contentView.addSubview(currentWeather)
        contentView.addSubview(minAndMaxLable)
        contentView.addSubview(currentDate)
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

}
