//
//  DetailSupplementViewController.swift
//  Supplement_Dispenser
//
//  Created by ROLF J. on 2022/07/14.
//

import UIKit

class DetailSupplementViewController: UIViewController {
    
    // MARK: Instance members
    // Detail View's Supplement Image
    private let detailSupplementImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        return imageView
    }()
    
    // Detail View's Supplement Name Description
    private let supplementNameLabel: UILabel = {
        let label = UILabel()
        label.text = "영양제명"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    // Detail View's Supplement Name
    private let detailSupplementName: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.layer.cornerRadius = 7
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.textAlignment = .center
        
        return label
    }()
    
    // Detail View's Single Intake Description
    private let singleIntakeLabel: UILabel = {
        let label = UILabel()
        label.text = "1회 섭취량"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    // Detail View's Single Intake Number
    private let detailSingleIntake: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.layer.cornerRadius = 35
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        
        return label
    }()
    
    // Detail View's Daily Intake Description
    private let dailyIntakeLabel: UILabel = {
        let label = UILabel()
        label.text = "1일 섭취횟수"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    // Detail View's Daily Intake Number
    private let detailDailyIntake: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.layer.cornerRadius = 35
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        
        return label
    }()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
