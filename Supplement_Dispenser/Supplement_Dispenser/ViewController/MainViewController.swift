//
//  MainViewController.swift
//  Supplement_Dispenser
//
//  Created by ROLF J. on 2022/07/12.
//

import UIKit
import SnapKit
import AVFoundation
import Photos
import BLTNBoard

public var notificationTime = ""
public var didClickNotificationNumber = 0
public var checkFinishDispenseNumber = 0
public var isQRScannedNumber = 0
public var dispenseInCoreDataIndexArray: [Int] = []
public var afterShowBulletin = 0

class MainViewController: UIViewController {
    
    var checkFinishDispenseTimer = Timer()
    
    // MARK: Instance members
    // Notification Center
    let notificationCenter = UNUserNotificationCenter.current()
    
    // Title label of MainView
    private let mainViewLabel: UILabel = {
        let label = UILabel()
        let checkExistUser = CoreDataManger.shared.getUserInformation()
        
        if checkExistUser != []  {
            label.text = "\(checkExistUser[0].username ?? "")의 영양제작소"
        } else {
            label.text = "영양제작소"
        }
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.sizeToFit()
        
        return label
    }()
    
    // 'Add Dispenser' Button
    private let addNewDispenserButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.Configuration.plain()
        button.setImage(UIImage(systemName: "plus.viewfinder"), for: .normal)
        button.tintColor = .systemBlue
        
        return button
    }()
    
    // MARK: TEST BUTTON
    // Test - Button can move to NewSupplementViewController
    private let newSupplementButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.Configuration.plain()
        button.setImage(UIImage(systemName: "plus.rectangle"), for: .normal)
        button.tintColor = .systemBlue
        
        return button
    }()
    
    // Test - Button send signal to server
    private let sendSignalToServer: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.Configuration.plain()
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .systemBlue
        
        return button
    }()
    // MARK: TEST BUTTON
    
    // MainView Table that show registerd supplements
    private let supplementTableView: UITableView = {
        let table = UITableView()
        table.register(MainViewSupplementsCell.self, forCellReuseIdentifier: MainViewSupplementsCell.identifier)
        table.backgroundColor = .systemGray6
        table.separatorStyle = .singleLine
        
        return table
    }()
    
    // MARK: View Life Cycle
    // viewDidLoad -> viewWillAppear -> viewDidAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        let checkUserInformation = CoreDataManger.shared.getUserInformation()
        if checkUserInformation != [] {
            print("\(String(describing: checkUserInformation[0].username)), \(String(describing: checkUserInformation[0].userApplicationEntityUUID))")
        } else {
            print("No User Information")
        }
        
        checkCameraPermission()
        checkPhotoLibraryPermission()
        requestNotificationAuthorization()
        mainViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        supplementTableView.reloadData()
        if didClickNotificationNumber == 1 {
            afterClickNotification()
            didClickNotificationNumber = 0
            notificationTime = ""
        }
        
        if isQRScannedNumber == 1 {
            showConnected()
            isQRScannedNumber = 0
        }
        
        if afterShowBulletin == 1 {
            makeNewContainerInServer()
            afterShowBulletin = 0
        }
    }
    
    // MARK: Functions
    // Configure MainView layout function
    private func mainViewLayout() {
        view.backgroundColor = .white
        addSubViews(views: [mainViewLabel, addNewDispenserButton, sendSignalToServer, supplementTableView])
        
        let checkExistUser = CoreDataManger.shared.getUserInformation()
        if checkExistUser != []  {
            mainViewLabel.text = "\(checkExistUser[0].username ?? "")의 영양제작소"
        } else {
            mainViewLabel.text = "영양제작소"
        }
        
        mainViewLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        addNewDispenserButton.snp.makeConstraints { make in
            make.centerY.equalTo(mainViewLabel.snp.centerY)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-5)
        }
        addNewDispenserButton.addTarget(self, action: #selector(pressAddNewDispenserButton), for: .touchUpInside)
        
        sendSignalToServer.snp.makeConstraints { make in
            make.centerY.equalTo(mainViewLabel.snp.centerY)
            make.trailing.equalTo(addNewDispenserButton.snp.leading).offset(-10)
        }
        sendSignalToServer.addTarget(self, action: #selector(pressSendSignalTestButton), for: .touchUpInside)
        
        supplementTableView.delegate = self
        supplementTableView.dataSource = self
        supplementTableView.dragInteractionEnabled = true
        supplementTableView.dragDelegate = self
        supplementTableView.dropDelegate = self
        supplementTableView.snp.makeConstraints { make in
            make.top.equalTo(mainViewLabel.snp.bottom).offset(10)
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }
    }
    
    // AddSubView all views in SuperView
    private func addSubViews(views: [UIView]) {
        for newView in views {
            view.addSubview(newView)
            newView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // Check to use camera on this application
    private func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                print("Camera: Permited")
            } else {
                print("Camera: Denied")
            }
        })
    }
    
    // Check to use photo library on this application
    private func checkPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization( { status in
            switch status {
            case .authorized:
                print("Album: Permited")
            case .denied:
                print("Album: Denied")
            case .restricted, .notDetermined:
                print("Album: Not selected")
            default:
                break
            }
        })
    }
    
    // Alert that notify supplement dispesnse done
    private func afterDispenseSupplements() {
        let doneToDispenseAlert = UIAlertController(title: "배출이 완료되었습니다!", message: "오늘도 건강한 하루 되세요!", preferredStyle: .alert)
        let checkButton = UIAlertAction(title: "확인", style: .default)
        doneToDispenseAlert.addAction(checkButton)
        present(doneToDispenseAlert, animated: true, completion: nil)
    }
    
    // Check new supplement's intake time to prevent massive notifications
    private func checkSameIntakeTime(newSupplementIntakeTime: String) -> Bool {
        let checkIntakeTime = CoreDataManger.shared.getSupplements()
        for checking in checkIntakeTime {
            if newSupplementIntakeTime == checking.takeTimeString {
                return true
            }
        }
        return false
    }

    // Show Connected ViewController
    func showConnected() {
        let connectedView = ConnectDispenserViewController()
        connectedView.modalPresentationStyle = .fullScreen
        connectedView.modalTransitionStyle = .crossDissolve
        present(connectedView, animated: true, completion: nil)
    }
    
    func checkNowTime() {
        let nowTimeFormatter = DateFormatter()
        nowTimeFormatter.dateFormat = "HH : mm"
        let nowTime = nowTimeFormatter.string(from: Date())
        notificationTime = nowTime
    }
    
    // After click Notification
    func afterClickNotification() {
        let checkDispenseSupplementAlert = UIAlertController(title: "영양제를 드시겠습니까?", message: nil, preferredStyle: .alert)
        let checkButton = UIAlertAction(title: "확인", style: .default, handler: {_ in self.sendSignalForDispenseSupplements() })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: { _ in TestSendingSignalViewController().post0Data() })
        checkDispenseSupplementAlert.addAction(cancelButton)
        checkDispenseSupplementAlert.addAction(checkButton)
        present(checkDispenseSupplementAlert, animated: true, completion: nil)
    }
    
    // Send datas for dispense supplements
    func sendSignalForDispenseSupplements() {
        
        TestSendingSignalViewController().post1Data(nfsdnNumber: "NFSDN_0001")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) {
            print("getData() 실행")
            TestSendingSignalViewController().getData(nfsdnNumber: "NFSDN_0001")
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            print("startCheckFinish() 실행")
            self.startCheckFinish()
        }
    }
    
    func startCheckFinish() {
        print("conData: \(conData)\n\n")
        if conData == "1" {
            checkTimeTrigger()
        }
    }
    
    func checkTimeTrigger() {
        print("checkTimeTrigger 실행")
        checkFinishDispenseTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkFinishDispense), userInfo: nil, repeats: true)
    }
    
    @objc func checkFinishDispense() {
        print("checkFinishDispense 실행 중")
        TestSendingSignalViewController().getData(nfsdnNumber: "NFSDN_0001")
        
        if conData == "0" {
            checkFinishDispenseTimer.invalidate()
            print("실행 완료")
            checkFinishDispenseNumber = 1
        } else {
            checkFinishDispenseNumber = 0
        }
        
        print("checkFinishDispenseNumber: \(checkFinishDispenseNumber)")
        
        if checkFinishDispenseNumber == 1 {
            setFinishNotification()
            checkFinishDispenseNumber = 0
        }
    }
    
    func setFinishNotification() {
        notificationCenter.removeAllPendingNotificationRequests()
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "영양제 배출이 완료되었습니다!"
        notificationContent.body = "오늘도 건강한 하루 되세요!"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // Request NotificationAuthorization
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        notificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    // Send Notification to user
    func setNotification(checkIntakeTimeString: String) {
        print("setNotification Function 실행됨\n\n")
        
        if checkSameIntakeTime(newSupplementIntakeTime: checkIntakeTimeString) == false {
            notificationCenter.removeAllPendingNotificationRequests()
            
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "영양제를 드실 시간입니다!"
            notificationContent.body = "\(checkIntakeTimeString)의 영양제를 드세요!"
            
            let hourStartIndex = checkIntakeTimeString.index(checkIntakeTimeString.startIndex, offsetBy: 0)
            let hourEndIndex = checkIntakeTimeString.index(checkIntakeTimeString.startIndex, offsetBy: 2)
            let minuteStartIndex = checkIntakeTimeString.index(checkIntakeTimeString.startIndex, offsetBy: 5)
            let minuteEndIndex = checkIntakeTimeString.index(checkIntakeTimeString.startIndex, offsetBy: 7)
            let hourOfTakeTime = checkIntakeTimeString[hourStartIndex..<hourEndIndex]
            let minuteOfTakeTime = checkIntakeTimeString[minuteStartIndex..<minuteEndIndex]
            var timeToNotificatoin = DateComponents()
            timeToNotificatoin.hour = Int(hourOfTakeTime)
            timeToNotificatoin.minute = Int(minuteOfTakeTime)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: timeToNotificatoin, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
            
            print("여기까지 실행됨\n\n")
            notificationCenter.add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // make new container in server
    func makeNewContainerInServer() {
        print("실행됨")
        
    if CoreDataManger.shared.getUserInformation() != [] {
        self.pressNewSupplementButton()
    } else {
        let newUserRegisterNumber = 1
        
        let makeNewContainerNameAlert = UIAlertController(title: "사용자의 이름을 입력해주세요!", message: nil, preferredStyle: .alert)
        let checkButton = UIAlertAction(title: "확인", style: .default) {_ in
            let newUserName = makeNewContainerNameAlert.textFields?[0].text
            let newUserUUID = UUID().uuidString
            CoreDataManger.shared.saveUserInformation(userName: newUserName ?? "", existUser: Int16(newUserRegisterNumber), userUUID: newUserUUID)
            
            let successToSaveAlert = UIAlertController(title: "저장이 완료되었습니다!", message: nil, preferredStyle: .alert)
            let checkButton = UIAlertAction(title: "확인", style: .default) {_ in
                self.pressNewSupplementButton()
            }
            successToSaveAlert.addAction(checkButton)
            self.present(successToSaveAlert, animated: true, completion: nil)
        }
        makeNewContainerNameAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "이곳에 사용자의 이름을 입력해주세요!"
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        makeNewContainerNameAlert.addAction(cancelButton)
        makeNewContainerNameAlert.addAction(checkButton)
        
        self.present(makeNewContainerNameAlert, animated: true, completion: nil)
    }
}
    
    // MARK: objc Functions
    // Add new Dispenser with this button function
    @objc private func pressAddNewDispenserButton() {
        let addDispenserViewController = AddDispenserWithQRViewController()
        addDispenserViewController.modalTransitionStyle = .coverVertical
        addDispenserViewController.modalPresentationStyle = .fullScreen
        present(addDispenserViewController, animated: true, completion: nil)
    }
    
    // MARK: TEST FUNCTION
    // Move to NewSupplementViewController function
    @objc private func pressNewSupplementButton() {
        let newSupplementViewController = NewSupplementViewController()
        newSupplementViewController.modalTransitionStyle = .coverVertical
        newSupplementViewController.modalPresentationStyle = .fullScreen
        present(newSupplementViewController, animated: true, completion: nil)
    }
    
    // Move to SendSinglaViewController function
    @objc private func pressSendSignalTestButton() {
        let testSendingSingalViewController = TestSendingSignalViewController()
        testSendingSingalViewController.modalTransitionStyle = .coverVertical
        testSendingSingalViewController.modalPresentationStyle = .formSheet
        present(testSendingSingalViewController, animated: true, completion: nil)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManger.shared.getSupplements().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainViewSupplementsCell.identifier, for: indexPath) as? MainViewSupplementsCell else { return UITableViewCell() }
        let getSupplementFromCoreData = CoreDataManger.shared.getSupplements()[indexPath.row]
        let supplementImageFromData: UIImage = UIImage(data: getSupplementFromCoreData.supplementImage!)!
        cell.makeCellValues(supplementImage: supplementImageFromData, supplementName: getSupplementFromCoreData.supplementName ?? "", singleIntake: getSupplementFromCoreData.singleIntakeCount ?? "", dailyIntake: getSupplementFromCoreData.dailyIntakeCount ?? "", takeTime: getSupplementFromCoreData.takeTimeString ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeToDelete = UIContextualAction(style: .destructive, title: "Delete", handler: { action, view, completionHandler in
            let checkDeleteAlert = UIAlertController(title: "삭제하시겠습니까?", message: "삭제한 데이터는 복구할 수 없습니다.", preferredStyle: .alert)
            let checkButton = UIAlertAction(title: "확인", style: .destructive) {_ in
                CoreDataManger.shared.deleteSupplement(deleteSupplementName: CoreDataManger.shared.getSupplements()[indexPath.row].supplementName ?? "")
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                completionHandler(true)
            }
            let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: {_ in tableView.reloadData()})
            checkDeleteAlert.addAction(cancelButton)
            checkDeleteAlert.addAction(checkButton)
            self.present(checkDeleteAlert, animated: true, completion: nil)
        })
        
        let swipeToEdit = UIContextualAction(style: .normal, title: "Edit", handler: { action, view, completionHandler in
            let checkEditAlert = UIAlertController(title: "수정하시겠습니까?", message: nil, preferredStyle: .alert)
            let checkButton = UIAlertAction(title: "확인", style: .default) {_ in
                editNumber = 1
                indexPathRowForEdit = indexPath.row
                
                let editSupplementViewController = NewSupplementViewController()
                editSupplementViewController.modalTransitionStyle = .coverVertical
                editSupplementViewController.modalPresentationStyle = .fullScreen
                self.present(editSupplementViewController, animated: true, completion: nil)
            }
            let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: {_ in tableView.reloadData()})
            checkEditAlert.addAction(cancelButton)
            checkEditAlert.addAction(checkButton)
            self.present(checkEditAlert, animated: true, completion: nil)
        })
        swipeToEdit.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [swipeToDelete, swipeToEdit])
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveCell = CoreDataManger.shared.getSupplements()[sourceIndexPath.row]
        let moveCellImageData = moveCell.supplementImage
        let originalCell = CoreDataManger.shared.getSupplements()[destinationIndexPath.row]
        let originalCellImageData = originalCell.supplementImage
        CoreDataManger.shared.deleteSupplement(deleteSupplementName: CoreDataManger.shared.getSupplements()[sourceIndexPath.row].supplementName!)
        CoreDataManger.shared.saveSupplement(newSupplementImage: moveCellImageData!, newSupplementName: moveCell.supplementName ?? "", newSingleIntake: moveCell.singleIntakeCount ?? "", newDailyIntake: moveCell.dailyIntakeCount ?? "", newTakeTime: moveCell.takeTimeString ?? "", nfdsnNumber: moveCell.nfsdnNumber ?? "")
        CoreDataManger.shared.deleteSupplement(deleteSupplementName: CoreDataManger.shared.getSupplements()[destinationIndexPath.row].supplementName!)
        CoreDataManger.shared.saveSupplement(newSupplementImage: originalCellImageData!, newSupplementName: originalCell.supplementName ?? "", newSingleIntake: originalCell.singleIntakeCount ?? "", newDailyIntake: originalCell.dailyIntakeCount ?? "", newTakeTime: originalCell.takeTimeString ?? "", nfdsnNumber: originalCell.nfsdnNumber ?? "")
    }
    
}

extension MainViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
    
}
