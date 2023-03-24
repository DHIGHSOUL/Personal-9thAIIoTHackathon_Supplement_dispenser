//
//  TestSendingSignalViewController.swift
//  Supplement_Dispenser
//
//  Created by ROLF J. on 2022/07/13.
//

import UIKit
import Foundation

public var conData = String()

class TestSendingSignalViewController: UIViewController {
    
    private let testPOST1Button: UIButton = {
        let button = UIButton()
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = .systemBlue
        buttonConfig.baseForegroundColor = .white
        button.configuration = buttonConfig
        button.setTitle("1 신호 보내기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.sizeToFit()
        
        return button
    }()
    
    private let testPOST0Button: UIButton = {
        let button = UIButton()
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = .systemBlue
        buttonConfig.baseForegroundColor = .white
        button.configuration = buttonConfig
        button.setTitle("0 신호 보내기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.sizeToFit()
        
        return button
    }()
    
    private let testSignalButton: UIButton = {
        let button = UIButton()
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = .systemBlue
        buttonConfig.baseForegroundColor = .white
        button.configuration = buttonConfig
        button.setTitle("1 신호 보내고 완료 기다리기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.sizeToFit()
        
        return button
    }()
    
    private let testGETButton: UIButton = {
        let button = UIButton()
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = .systemBlue
        buttonConfig.baseForegroundColor = .white
        button.configuration = buttonConfig
        button.setTitle("신호 받기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.sizeToFit()
        
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        let buttonConfiguration = UIButton.Configuration.plain()
        button.configuration = buttonConfiguration
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemBlue
        
        return button
    }()
    
    private let deleteUserInformationButton: UIButton = {
        let button = UIButton()
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = .systemBlue
        buttonConfig.baseForegroundColor = .white
        button.configuration = buttonConfig
        button.setTitle("userinformation 코어데이터 삭제하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.sizeToFit()
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTestlayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        testSignalButton.addTarget(self, action: #selector(testSignal), for: .touchUpInside)
    }
    
    private func makeTestlayout() {
        view.backgroundColor = .white
        let views = [testPOST1Button, testPOST0Button, testSignalButton, testGETButton, deleteUserInformationButton, dismissButton]
        
        for newView in views {
            view.addSubview(newView)
        }
        
        testPOST1Button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalTo(view.frame.width/5)
            make.trailing.equalTo(-(view.frame.width/5))
        }
        testPOST1Button.addTarget(self, action: #selector(sendTestSignal1), for: .touchUpInside)
        
        testPOST0Button.snp.makeConstraints { make in
            make.top.equalTo(testPOST1Button.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalTo(view.frame.width/5)
            make.trailing.equalTo(-(view.frame.width/5))
        }
        testPOST0Button.addTarget(self, action: #selector(sendTestSignal0), for: .touchUpInside)
        
        testGETButton.snp.makeConstraints { make in
            make.top.equalTo(testPOST0Button.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalTo(view.frame.width/5)
            make.trailing.equalTo(-(view.frame.width/5))
        }
        testGETButton.addTarget(self, action: #selector(getTestSignal), for: .touchUpInside)
        
        testSignalButton.snp.makeConstraints { make in
            make.top.equalTo(testGETButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalTo(view.frame.width/5)
            make.trailing.equalTo(-(view.frame.width/5))
        }
        
        deleteUserInformationButton.snp.makeConstraints { make in
            make.top.equalTo(testSignalButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalTo(view.frame.width/5)
            make.trailing.equalTo(-(view.frame.width/5))
        }
        deleteUserInformationButton.addTarget(self, action: #selector(deleteUserInformation), for: .touchUpInside)
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(view.safeAreaInsets)
        }
        dismissButton.addTarget(self, action: #selector(pressDismissButton), for: .touchUpInside)
        
    }
    
    func post1Data(nfsdnNumber: String) {
            // [URL 지정 및 파라미터 값 지정 실시]
            let urlComponents = URLComponents(string: "http://203.253.128.177:7579/Mobius/NFSDN_0001/data")
            
            let parameters = "{\n    \"m2m:cin\": {\n        \"con\": \"1\"\n    }\n}   "
            let postData = parameters.data(using: .utf8)
            
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
    
    func post0Data() {
        // [URL 지정 및 파라미터 값 지정 실시]
        let urlComponents = URLComponents(string: "http://203.253.128.177:7579/Mobius/NFSDN_0001/data")
        
        let parameters = "{\n    \"m2m:cin\": {\n        \"con\": \"0\"\n    }\n}   "
        let postData = parameters.data(using: .utf8)
        
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
    
    func getData(nfsdnNumber: String) {
        // [URL 지정 및 파라미터 값 지정 실시]
        let urlComponents = URLComponents(string: "http://203.253.128.177:7579/Mobius/NFSDN_0001/data/la")

        // [http 통신 타입 및 헤더 지정 실시]
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.addValue("application/json", forHTTPHeaderField: "Accept")
        requestURL.addValue("12345", forHTTPHeaderField: "X-M2M-RI")
        requestURL.addValue("SluN3OkDey-", forHTTPHeaderField: "X-M2M-Origin")
        requestURL.addValue("application/vnd.onem2m-res+json; ty=4", forHTTPHeaderField: "Content-Type") // POST

        requestURL.httpMethod = "GET" // GET

        // [http 요쳥을 위한 URLSessionDataTask 생성]
        print("")
        print("====================================")
        print("[requestGet : http get 요청 실시]")
        print("url : ", requestURL)
        print("====================================")
        print("")

        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            // [error가 존재하면 종료]
            guard error == nil else {
                print("")
                print("====================================")
                print("[requestGet : http get 요청 실패]")
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
                print("[requestGet : http get 요청 에러]")
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
            print("[requestGet : http get 요청 성공]")
            print("resultCode : ", resultCode)
            print("resultLen : ", resultLen)
            print("resultString : ", resultString)
            print("====================================")
            print("")

            let jsonDecoder = JSONDecoder()
            let parsingData = try? jsonDecoder.decode(didDone.self, from: data ?? Data())
            print("parsingData.m2m:cin.con = \(parsingData?.m2m.con ?? "")")
            conData = (parsingData?.m2m.con)!
        }
        // network 통신 실행
        dataTask.resume()
    }
    
    func postCount() {
        // [URL 지정 및 파라미터 값 지정 실시]
        var urlComponents = URLComponents(string: "http://203.253.128.177:7579/Mobius/phone/count")
        
        let countParamNumber = "2"
        
        let parameters = "{\n    \"m2m:cin\": {\n        \"con\": \"\(countParamNumber)\"\n    }\n}   "
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
    
    @objc private func testSignal() {
        MainViewController().sendSignalForDispenseSupplements()
    }
    
    @objc private func pressDismissButton() {
        dismiss(animated: true)
    }
    
    @objc private func sendTestSignal1() {
        post1Data(nfsdnNumber: "NFDSN_0001")
    }
    
    @objc private func sendTestSignal0() {
        post0Data()
    }
    
    @objc private func getTestSignal() {
        getData(nfsdnNumber: "NFDSN_0001")
    }
    
    @objc private func deleteUserInformation() {
        let getUserInformation = CoreDataManger.shared.getUserInformation()
        
        if getUserInformation != [] {
            CoreDataManger.shared.deleteUserInformation(userName: getUserInformation[0].username ?? "")
        }
    }
}

