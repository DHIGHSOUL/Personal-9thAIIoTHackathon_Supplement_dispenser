//
//  MainViewSupplementsCell.swift
//  Supplement_Dispenser
//
//  Created by ROLF J. on 2022/07/12.
//

import UIKit

class MainViewSupplementsCell: UITableViewCell {

    // Identifier to register
    static let identifier = "MainViewSupplementsCell"
    
    // MARK: Instance members
    // Image of supplement
    private let supplementImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    // Name of supplement
    private let supplementNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        
        return label
    }()
    
    // Number that how many times take supplement on day
    private let dailyIntakeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        
        return label
    }()
    
    // Number that how many supplements take once
    private let singleIntakeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        
        return label
    }()
    
    // Number that when provide alert to get supplement on time
    private let takeTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        
        return label
    }()
    
    // Container number
//    private let remainingColorAlert: UITextField = {
//        let field = UITextField()
//        field.font = UIFont.boldSystemFont(ofSize: 25)
//        field.textAlignment = .center
//        field.backgroundColor = .systemBlue
//        field.layer.cornerRadius = 20
//        field.sizeToFit()
//        field.clipsToBounds = true
//
//        return field
//    }()
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        MainViewTableCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    // Configure TableViewCell layout function
    private func MainViewTableCellLayout() {
        contentView.backgroundColor = .white
        addSubViews(views: [supplementImageView, supplementNameLabel, dailyIntakeLabel, singleIntakeLabel, takeTimeLabel])
        
        supplementImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        supplementNameLabel.snp.makeConstraints { make in
            make.top.equalTo(supplementImageView.snp.top).offset(-3)
            make.leading.equalTo(supplementImageView.snp.trailing).offset(10)
        }
        
        dailyIntakeLabel.snp.makeConstraints { make in
            make.top.equalTo(supplementNameLabel.snp.bottom).offset(6)
            make.leading.equalTo(supplementImageView.snp.trailing).offset(10)
        }
        
        singleIntakeLabel.snp.makeConstraints { make in
            make.top.equalTo(dailyIntakeLabel.snp.bottom).offset(6)
            make.leading.equalTo(supplementImageView.snp.trailing).offset(10)
        }
        
        takeTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(singleIntakeLabel.snp.bottom).offset(6)
            make.leading.equalTo(supplementImageView.snp.trailing).offset(10)
        }
        
//        remainingColorAlert.snp.makeConstraints { make in
//            make.centerY.equalTo(contentView)
//            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-10)
//            make.size.equalTo(CGSize(width: 40, height: 40))
//        }
        
    }
    
    // AddSubView all views in ContentView
    private func addSubViews(views: [UIView]) {
        for newView in views {
            contentView.addSubview(newView)
            newView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func makeCellValues(supplementImage: UIImage, supplementName: String, singleIntake: String, dailyIntake: String, takeTime: String) {
        supplementImageView.image = supplementImage
        supplementNameLabel.text = supplementName
        singleIntakeLabel.text = "1회 섭취량 - \(singleIntake)"
        dailyIntakeLabel.text = "1일 섭취횟수 - \(dailyIntake)"
        takeTimeLabel.text = "섭취시간 - \(takeTime)"
    }
    
}
