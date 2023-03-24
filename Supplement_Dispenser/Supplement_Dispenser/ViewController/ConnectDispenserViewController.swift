//
//  ConnectDispenserViewController.swift
//  Supplement_Dispenser
//
//  Created by ROLF J. on 2022/07/23.
//

import UIKit
import BLTNBoard

class ConnectDispenserViewController: UIViewController {
    
    lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = {
            let connectedPage = BLTNPageItem(title: "환영합니다!")
            connectedPage.image = UIImage(named: "CapsuleDesign")
            connectedPage.appearance.titleTextColor = .black
            connectedPage.descriptionText = "기기에서 사용할 영양제 정보를 입력해 주세요!"
            connectedPage.isDismissable = false
            connectedPage.requiresCloseButton = false
            
            return connectedPage
        }()
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bulletinManager.backgroundViewStyle = .blurredDark
        bulletinManager.showBulletin(above: self)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            self.bulletinManager.dismissBulletin(animated: true)
            afterShowBulletin = 1
            self.dismiss(animated: true)
        }
    }

}
