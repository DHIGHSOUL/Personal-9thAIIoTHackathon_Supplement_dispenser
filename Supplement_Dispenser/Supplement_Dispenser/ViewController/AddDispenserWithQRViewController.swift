//
//  AddDispenserWithQRViewController.swift
//  Supplement_Dispenser
//
//  Created by ROLF J. on 2022/07/21.
//

import UIKit
import AVFoundation

public var nfsdnNumberToSave: String?

class AddDispenserWithQRViewController: UIViewController {
    
    // MARK: Instance members
    // Real Time Capture Instance
    private let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDispenserViewLayout()
    }
    
    // MARK: Function
    
    
    private func addDispenserViewLayout() {
        view.backgroundColor = .white
        
        basicQRSetting()
    }
    
    // AddSubView all views in SuperView
    private func addSubViews(views: [UIView]) {
        for newView in views {
            view.addSubview(newView)
            newView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func basicQRSetting() {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            setVideoLayer()
            setGuideCrossLineView()
            setTestImage()
            //            setDismissButton()
            
            captureSession.startRunning()
        } catch {
            print("QR error")
        }
    }
    
    private func setVideoLayer() {
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = view.layer.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)
    }
    
    private func setGuideCrossLineView() {
        let guideCrossLine = UIImageView()
        guideCrossLine.image = UIImage(systemName: "plus")
        guideCrossLine.tintColor = .green
        guideCrossLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guideCrossLine)
        guideCrossLine.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.height.equalTo(30)
        }
    }
    
    private func setTestImage() {
        let dismissButtonImage = UIImageView()
        dismissButtonImage.image = UIImage(systemName: "xmark")
        dismissButtonImage.tintColor = .systemBlue
        dismissButtonImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dismissButtonImage)
        dismissButtonImage.snp.makeConstraints { make in
            make.top.equalTo(view).offset(50)
            make.trailing.equalTo(view).offset(-15)
            make.width.height.equalTo(20)
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pressDismissButton))
        dismissButtonImage.isUserInteractionEnabled = true
        dismissButtonImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setDismissButton() {
        let dismissButton = UIButton()
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.configuration = UIButton.Configuration.plain()
        dismissButton.tintColor = .systemBlue
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.sizeToFit()
        dismissButton.clipsToBounds = true
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view).offset(50)
            make.trailing.equalTo(view).offset(-50)
        }
        dismissButton.addTarget(self, action: #selector(pressDismissButton), for: .touchUpInside)
    }
    
    // MARK: @objc Function
    // When pressing dismiss button
    @objc private func pressDismissButton() {
        dismiss(animated: true)
    }
}

extension AddDispenserWithQRViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else { return }
            
            nfsdnNumberToSave = stringValue
            print("\(stringValue)\n\n\n\n\n ")
            
            self.captureSession.stopRunning()
            isQRScannedNumber = 1
            self.dismiss(animated: true, completion: nil)
        }
    }
}

