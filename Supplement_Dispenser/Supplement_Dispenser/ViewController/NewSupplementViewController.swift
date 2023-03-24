//
//  NewSupplementViewController.swift
//  Supplement_Dispenser
//
//  Created by ROLF J. on 2022/07/12.
//

import UIKit

// Check to usage of NewSupplementViewController between Make new supplement data or edit supplement data
public var editNumber = 0
// Get indexPath.row Int information for edit
public var indexPathRowForEdit = 0

class NewSupplementViewController: UIViewController {
    
    // MARK: Instance members
    
    // Array to select single intake count
    let singleIntakeNumberArray: [String] = ["1", "2", "3"]
    let dailyIntakeNumberArray: [String] = ["1", "2", "3"]
    
    // Title Label of NewSupplementView
    private let newSupplementViewLabel: UILabel = {
        let label = UILabel()
        if editNumber == 1 {
            label.text = "영양제 수정하기"
        } else {
            label.text = "새로운 영양제"
        }
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        return label
    }()
    
    // Dismiss Button which cancel making new supplement TableViewCell
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.Configuration.plain()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemBlue
        
        return button
    }()
    
    // Show new image imported into camera or album
    private var newSupplementImageView: UIImageView = {
        let imageView = UIImageView()
        
        if editNumber == 1 {
            let imageDataForEdit = CoreDataManger.shared.getSupplements()[indexPathRowForEdit].supplementImage
            imageView.image = UIImage(data: imageDataForEdit!)
        } else {
            imageView.image = nil
        }
        
        imageView.backgroundColor = .systemGray6
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        return imageView
    }()
    
    // Picker that get new image from camera or album
    private let getSupplementImagePicker = UIImagePickerController()
    
    // Button to get image from camera or album
    private let getNewSupplementImageButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.Configuration.plain()
        button.setTitle("사진 가져오기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.clipsToBounds = true
        button.tintColor = .systemBlue
        
        return button
    }()
    
    // Supplement Name Label
    private let supplementNameLabel: UILabel = {
        let label = UILabel()
        label.text = "영양제명"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    // TextField for input new supplement name
    private let supplementNameTextField: UITextField = {
        let textField = UITextField()
        
        if editNumber == 1 {
            textField.text = CoreDataManger.shared.getSupplements()[indexPathRowForEdit].supplementName
        } else {
            textField.text = ""
        }
        
        textField.layer.cornerRadius = 7
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.textAlignment = .center
        
        return textField
    }()
    
    // Count single intake label
    private let singleIntakeLabel: UILabel = {
        let label = UILabel()
        label.text = "1회 섭취량"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    // Picker View to select single intake
    private let intakePickerView: UIPickerView = {
        let picker = UIPickerView()
        
        return picker
    }()
    
    // TextField that contain single intake count
    private let singleIntakeTextField: UITextField = {
        let field = UITextField()
        
        if editNumber == 1 {
            field.text = CoreDataManger.shared.getSupplements()[indexPathRowForEdit].singleIntakeCount
        } else {
            field.text = ""
        }
        
        field.font = UIFont.boldSystemFont(ofSize: 20)
        field.textAlignment = .center
        field.layer.cornerRadius = 35
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.darkGray.cgColor
        field.tintColor = .clear
        
        return field
    }()
    
    // Count daily intake label
    private let dailyIntakeLabel: UILabel = {
        let label = UILabel()
        label.text = "1일 섭취횟수"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    // TextField to show selected daily intake time
    private let dailyIntakeTextField: UITextField = {
        let field = UITextField()
        
        if editNumber == 1 {
            field.text = CoreDataManger.shared.getSupplements()[indexPathRowForEdit].dailyIntakeCount
        } else {
            field.text = ""
        }
        
        field.font = UIFont.boldSystemFont(ofSize: 20)
        field.textAlignment = .center
        field.layer.cornerRadius = 35
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.darkGray.cgColor
        field.tintColor = .clear
        return field
    }()
    
    // ToolBar to use picker view
    private let intakePickerToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = .systemGray4
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.sizeToFit()
        
        return toolBar
    }()
    
    // Time to take supplement label
    private let takeTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "섭취 시간"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    // TextField to show selected intake time
    private let takeTimeTextField: UITextField = {
        let field = UITextField()
        
        if editNumber == 1 {
            field.text = CoreDataManger.shared.getSupplements()[indexPathRowForEdit].takeTimeString
        } else {
            field.text = ""
        }
        
        field.textAlignment = .center
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.darkGray.cgColor
        field.tintColor = .clear
        
        return field
    }()
    
    // Date Picker to select intake time
    private let takeTimeDatePicker = UIDatePicker()
    
    // Date Picker Toolbar
    private let takeTimeDatePickerToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = .systemGray4
        toolBar.sizeToFit()
        
        return toolBar
    }()
    
    // Button that save new supplements' imformations
    private let saveButton: UIButton = {
        let button = UIButton()
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = .systemBlue
        buttonConfiguration.baseForegroundColor = .white
        button.configuration = buttonConfiguration
        button.setTitle("저장하기", for: .normal)
        
        return button
    }()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        getSupplementImagePicker.delegate = self
        intakePickerView.delegate = self
        intakePickerView.dataSource = self
        newSupplementViewLayout()
    }
    
    // MARK: Functions
    // Configure NewSupplementView layout function
    private func newSupplementViewLayout() {
        view.backgroundColor = .white
        addSubViews(views: [newSupplementViewLabel, dismissButton, newSupplementImageView, getNewSupplementImageButton, supplementNameLabel, supplementNameTextField, singleIntakeLabel, singleIntakeTextField, dailyIntakeLabel, dailyIntakeTextField, takeTimeLabel, takeTimeTextField, saveButton])
        
        newSupplementViewLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.centerY.equalTo(newSupplementViewLabel.snp.centerY)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        dismissButton.addTarget(self, action: #selector(pressDismissButton), for: .touchUpInside)
        
        newSupplementImageView.snp.makeConstraints { make in
            make.top.equalTo(newSupplementViewLabel.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.height.equalTo(CGFloat(view.frame.height/6))
        }
        newSupplementImageView.layer.cornerRadius = CGFloat(view.frame.height/12)
        newSupplementImageView.clipsToBounds = true
        
        getNewSupplementImageButton.snp.makeConstraints { make in
            make.top.equalTo(newSupplementImageView.snp.bottom).offset(5)
            make.centerX.equalTo(view)
            make.width.equalTo(view.safeAreaLayoutGuide)
        }
        getNewSupplementImageButton.addTarget(self, action: #selector(pressGetNewSupplementImageButton), for: .touchUpInside)
        
        supplementNameLabel.snp.makeConstraints { make in
            make.top.equalTo(getNewSupplementImageButton.snp.bottom).offset(10)
            make.centerX.equalTo(view)
        }
        
        supplementNameTextField.snp.makeConstraints { make in
            make.top.equalTo(supplementNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(view.frame.width/5)
            make.trailing.equalTo(-(view.frame.width/5))
            make.height.equalTo(50)
        }
        
        singleIntakeLabel.snp.makeConstraints { make in
            make.top.equalTo(supplementNameTextField.snp.bottom).offset(10)
            make.centerX.equalTo(view).offset(-60)
        }
        
        let donePickSingleIntakeButton = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(pressDonePickIntakeButton))
        let spaceBetweenButtons = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelPickSingleIntakeButton = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(pressCancelPickIntakeButton))
        intakePickerToolBar.setItems([cancelPickSingleIntakeButton, spaceBetweenButtons, donePickSingleIntakeButton], animated: true)
        intakePickerToolBar.isUserInteractionEnabled = true
        
        singleIntakeTextField.snp.makeConstraints { make in
            make.top.equalTo(singleIntakeLabel.snp.bottom).offset(5)
            make.centerX.equalTo(singleIntakeLabel.snp.centerX)
            make.width.height.equalTo(70)
        }
        singleIntakeTextField.inputView = intakePickerView
        singleIntakeTextField.inputAccessoryView = intakePickerToolBar
        
        dailyIntakeLabel.snp.makeConstraints { make in
            make.top.equalTo(supplementNameTextField.snp.bottom).offset(10)
            make.centerX.equalTo(view).offset(60)
        }
        
        dailyIntakeTextField.snp.makeConstraints { make in
            make.top.equalTo(dailyIntakeLabel.snp.bottom).offset(5)
            make.centerX.equalTo(dailyIntakeLabel.snp.centerX)
            make.width.height.equalTo(70)
        }
        dailyIntakeTextField.inputView = intakePickerView
        dailyIntakeTextField.inputAccessoryView = intakePickerToolBar
        
        takeTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(dailyIntakeTextField.snp.bottom).offset(10)
            make.centerX.equalTo(view)
        }
        
        let doneSelectTimeButton = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(pressDoneSelectTakeTimeButton))
        let cancelSelectTimeButton = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(pressCancelSelectTakeTimeButton))
        takeTimeDatePickerToolBar.setItems([cancelSelectTimeButton, spaceBetweenButtons, doneSelectTimeButton], animated: true)
        takeTimeDatePickerToolBar.isUserInteractionEnabled = true
        takeTimeTextField.snp.makeConstraints { make in
            make.top.equalTo(takeTimeLabel.snp.bottom).offset(5)
            make.leading.equalTo(view.frame.width/5)
            make.trailing.equalTo(-(view.frame.width/5))
            make.height.equalTo(50)
        }
        takeTimeDatePicker.preferredDatePickerStyle = .wheels
        takeTimeDatePicker.datePickerMode = .time
        takeTimeTextField.inputView = takeTimeDatePicker
        takeTimeTextField.inputAccessoryView = takeTimeDatePickerToolBar
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.frame.width/4)
            make.trailing.equalTo(-(view.frame.width/4))
        }
        saveButton.addTarget(self, action: #selector(pressSaveButton), for: .touchUpInside)
    }
    
    // AddSubView all views in SuperView
    private func addSubViews(views: [UIView]) {
        for newView in views {
            view.addSubview(newView)
            newView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // Open Camera to get image
    private func openCamera() {
        getSupplementImagePicker.sourceType = .camera
        present(getSupplementImagePicker, animated: true, completion: nil)
    }
    
    // Open Photo Library to get image
    private func openAlbum() {
        getSupplementImagePicker.sourceType = .photoLibrary
        present(getSupplementImagePicker, animated: true, completion: nil)
    }
    
    // Check Supplement Image View has image inside
    private func checkNoSupplementImage() -> Bool {
        if newSupplementImageView.image == nil {
            let noImageAlert = UIAlertController(title: "사진이 없습니다!", message: "영양제 사진을 선택해주세요!", preferredStyle: .alert)
            let checkButton = UIAlertAction(title: "확인", style: .default)
            noImageAlert.addAction(checkButton)
            present(noImageAlert, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    
    // Check Supplement Name TextField has name of supplement
    private func checkNoSupplementName() -> Bool {
        if supplementNameTextField.text == "" {
            let noNameAlert = UIAlertController(title: "영양제명이 없습니다!", message: "영양제 이름을 입력해주세요!", preferredStyle: .alert)
            let checkButton = UIAlertAction(title: "확인", style: .default)
            noNameAlert.addAction(checkButton)
            present(noNameAlert, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    
    // Check Single Intake TextField has number string inside
    private func checkNoSingleIntake() -> Bool {
        if singleIntakeTextField.text == "" {
            let noSingleIntakeAlert = UIAlertController(title: "1회 섭취량이 없습니다!", message: "1회 섭취량을 선택해주세요!", preferredStyle: .alert)
            let checkButton = UIAlertAction(title: "확인", style: .default)
            noSingleIntakeAlert.addAction(checkButton)
            present(noSingleIntakeAlert, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    
    // Check Daily Intake TextField has number string inside
    private func checkNoDailyIntake() -> Bool {
        if singleIntakeTextField.text == "" {
            let noDailyIntakeAlert = UIAlertController(title: "1일 섭취횟수이 없습니다!", message: "1일 섭취횟수을 선택해주세요!", preferredStyle: .alert)
            let checkButton = UIAlertAction(title: "확인", style: .default)
            noDailyIntakeAlert.addAction(checkButton)
            present(noDailyIntakeAlert, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    
    // Check takeTime Textfield has time information to intake supplement
    private func checkNoTakeTime() -> Bool {
        if takeTimeTextField.text == "" {
            let noTakeTimeAlert = UIAlertController(title: "섭취 시간이 없습니다!", message: "섭취 시간을 선택해주세요!", preferredStyle: .alert)
            let checkButton = UIAlertAction(title: "확인", style: .default)
            noTakeTimeAlert.addAction(checkButton)
            present(noTakeTimeAlert, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    
    // Save new supplement informations in Core Data
    private func saveInCoreData() {
        let saveSupplementImage = newSupplementImageView.image?.jpegData(compressionQuality: 1.0)
        CoreDataManger.shared.saveSupplement(newSupplementImage: saveSupplementImage!, newSupplementName: supplementNameTextField.text ?? "", newSingleIntake: singleIntakeTextField.text ?? "", newDailyIntake: dailyIntakeTextField.text ?? "", newTakeTime: takeTimeTextField.text ?? "", nfdsnNumber: nfsdnNumberToSave ?? "")
    }
    
    // Clear everything on view
    private func clearThisView() {
        newSupplementImageView.image = nil
        supplementNameTextField.text = ""
        singleIntakeTextField.text = ""
        dailyIntakeTextField.text = ""
        takeTimeTextField.text = ""
    }
    
    // POST count initialization
    private func postCountInitialization() {
        var urlComponents: URLComponents?
        
        // [URL 지정 및 파라미터 값 지정 실시]
        if editNumber == 1 {
            urlComponents = URLComponents(string: "http://203.253.128.177:7579/Mobius/\(CoreDataManger.shared.getSupplements()[indexPathRowForEdit].nfsdnNumber ?? "")/count")
        } else {
            urlComponents = URLComponents(string: "http://203.253.128.177:7579/Mobius/\(nfsdnNumberToSave ?? "")/count")
        }
        
        let countParamNumber = singleIntakeTextField.text
        
        let parameters = "{\n    \"m2m:cin\": {\n        \"con\": \"\(countParamNumber ?? "")\"\n    }\n}   "
        let postData = parameters.data(using: .utf8)
        
        let paramQuery = URLQueryItem(name: "con", value: "2")
        urlComponents?.queryItems?.append(paramQuery) // 파라미터 지정
        
        // [http 통신 타입 및 헤더 지정 실시]
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.addValue("application/json", forHTTPHeaderField: "Accept")
        requestURL.addValue("12345", forHTTPHeaderField: "X-M2M-RI")
        requestURL.addValue("SluN3OkDey-", forHTTPHeaderField: "X-M2M-Origin")
        requestURL.addValue("application/vnd.onem2m-res+json; ty=4", forHTTPHeaderField: "Content-Type") // POST
        
        requestURL.httpMethod = "POST" // POST
        requestURL.httpBody = postData
        
        // [http 요쳥을 위한 URLSessionDataTask 생성]
        print("")
        print("====================================")
        print("[requestPOST : http post 요청 실시]")
        print("url : ", requestURL)
        print("====================================")
        print("")
        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            
            // [error가 존재하면 종료]
            guard error == nil else {
                print("")
                print("====================================")
                print("[requestPOST : http post 요청 실패]")
                print("fail : ", error?.localizedDescription ?? "")
                print("====================================")
                print("")
                return
            }
            
            // [status 코드 체크 실시]
            let successsRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successsRange.contains(statusCode)
            else {
                print("")
                print("====================================")
                print("[requestPOST : http post 요청 에러]")
                print("error : ", (response as? HTTPURLResponse)?.statusCode ?? 0)
                print("msg : ", (response as? HTTPURLResponse)?.description ?? "")
                print("====================================")
                print("")
                return
            }
            
            // [response 데이터 획득, utf8인코딩을 통해 string형태로 변환]
            let resultCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            let resultLen = data! // 데이터 길이
            let resultString = String(data: resultLen, encoding: .utf8) ?? "" // 응답 메시지
            print("")
            print("====================================")
            print("[requestPOST : http post 요청 성공]")
            print("resultCode : ", resultCode)
            print("resultLen : ", resultLen)
            print("resultString : ", resultString)
            print("====================================")
            print("")
        }
        
        // network 통신 실행
        dataTask.resume()
    }
    
    // MARK: objc Functions
    // Click dismiss('xmark') button
    @objc private func pressDismissButton() {
        dismiss(animated: true)
    }
    
    // AlertController for get new image
    @objc private func pressGetNewSupplementImageButton() {
        let getImageSelectAlert = UIAlertController(title: "사진 가져오기", message: nil, preferredStyle: .actionSheet)
        let getImageWithCamera = UIAlertAction(title: "카메라", style: .default) { _ in self.openCamera()}
        let getImageWithAlbum = UIAlertAction(title: "앨범", style: .default) { _ in self.openAlbum()}
        let cancelGetImage = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        getImageSelectAlert.addAction(getImageWithCamera)
        getImageSelectAlert.addAction(getImageWithAlbum)
        getImageSelectAlert.addAction(cancelGetImage)
        
        present(getImageSelectAlert, animated: true, completion: nil)
    }
    
    // Done to pick single intake number
    @objc private func pressDonePickIntakeButton() {
        if singleIntakeTextField.text == "" { singleIntakeTextField.text = "1" }
        if dailyIntakeTextField.text == "" { dailyIntakeTextField.text = "1" }
        singleIntakeTextField.resignFirstResponder()
        dailyIntakeTextField.resignFirstResponder()
    }
    
    // Cancel to get single intake number
    @objc private func pressCancelPickIntakeButton() {
        singleIntakeTextField.text = ""
        dailyIntakeTextField.text = ""
        singleIntakeTextField.resignFirstResponder()
        dailyIntakeTextField.resignFirstResponder()
    }
    
    // Done to select dispenser working time
    @objc private func pressDoneSelectTakeTimeButton() {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .none
        timeFormatter.dateFormat = "HH : mm"
        
        takeTimeTextField.text = timeFormatter.string(from: takeTimeDatePicker.date)
        takeTimeTextField.resignFirstResponder()
    }
    
    // Cancel to select dispenser working time
    @objc private func pressCancelSelectTakeTimeButton() {
        takeTimeTextField.resignFirstResponder()
    }
    
    // Save new supplement's informations
    @objc private func pressSaveButton() {
        if checkNoSupplementImage() == true && checkNoSupplementName() == true && checkNoSingleIntake() == true && checkNoDailyIntake() == true && checkNoTakeTime() == true {
            if editNumber == 1 {
                let editRequestAlert = UIAlertController(title: "수정하시겠습니까?", message: nil, preferredStyle: .alert)
                let checkButton = UIAlertAction(title: "확인", style: .default) {_ in
                    let successToEditAlert = UIAlertController(title: "수정되었습니다!", message: nil, preferredStyle: .alert)
                    let checkButton = UIAlertAction(title: "확인", style: .default) {_ in
                        CoreDataManger.shared.deleteSupplement(deleteSupplementName: CoreDataManger.shared.getSupplements()[indexPathRowForEdit].supplementName ?? "")
                        MainViewController().setNotification(checkIntakeTimeString: self.takeTimeTextField.text ?? "")
                        self.saveInCoreData()
                        self.postCountInitialization()
                        editNumber = 0
                        indexPathRowForEdit = 0
                        self.clearThisView()
                        self.dismiss(animated: true)
                    }
                    successToEditAlert.addAction(checkButton)
                    self.present(successToEditAlert, animated: true, completion: nil)
                }
                let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                editRequestAlert.addAction(cancelButton)
                editRequestAlert.addAction(checkButton)
                present(editRequestAlert, animated: true, completion: nil)
            } else {
                let saveRequestAlert = UIAlertController(title: "저장하시겠습니까?", message: nil, preferredStyle: .alert)
                let checkButton = UIAlertAction(title: "확인", style: .default) { _ in
                    let successToSaveAlert = UIAlertController(title: "저장되었습니다!", message: nil, preferredStyle: .alert)
                    let checkButton = UIAlertAction(title: "확인", style: .default) {_ in
                        MainViewController().setNotification(checkIntakeTimeString: self.takeTimeTextField.text ?? "")
                        self.saveInCoreData()
                        self.postCountInitialization()
                        self.clearThisView()
                        self.dismiss(animated: true)
                    }
                    successToSaveAlert.addAction(checkButton)
                    self.present(successToSaveAlert, animated: true, completion: nil)
                }
                let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                saveRequestAlert.addAction(cancelButton)
                saveRequestAlert.addAction(checkButton)
                present(saveRequestAlert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Overrided fucntion
    // Keyboard going down if click other view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension NewSupplementViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newSupplementImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension NewSupplementViewController: UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return singleIntakeNumberArray.count
        } else {
            return dailyIntakeNumberArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return singleIntakeNumberArray[row]
        } else {
            return dailyIntakeNumberArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            singleIntakeTextField.text = singleIntakeNumberArray[row]
        } else {
            dailyIntakeTextField.text = dailyIntakeNumberArray[row]
        }
    }
    
}
