//
//  CameraVC.swift
//  Ice Cream Tracker
//
//  Created by Christopher Hovey on 4/13/19.
//  Copyright © 2019 Chris Hovey. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
    
    @IBOutlet weak var viewTakePhoto: UIView!
    @IBOutlet weak var btnTakePhoto: UIButton!
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCameraSession()
        setUpDevice()
        setUpInputOutput()
        setUpPreviewLayer()
        startRunningCaptureSession()
    }
    
    //MARK: - IBActions
    
    @IBAction func cameraBtnPress(_ sender: AnyObject){
        var settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    
    //MARK: - Functions
    
    
    func setUpCameraSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    func setUpDevice(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let devices = deviceDiscoverySession.devices
        for device in devices{
            if device.position == .back{
                backCamera = device
            }
            if device.position == .front{
                frontCamera = device
            }
        }
        currentCamera = backCamera
        
    }
    func setUpInputOutput(){
        
        guard let currentCamera = currentCamera else{
            return
        }
        do{
            let captureInputDevice = try AVCaptureDeviceInput(device: currentCamera)
            captureSession.addInput(captureInputDevice)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            if let photoOutput = photoOutput{
                captureSession.addOutput(photoOutput)
            }
        }catch{
            print("error inputOutput", error.localizedDescription)
        }
    }
    func setUpPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = .resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = .portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
    }
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
    
    

}

extension CameraVC: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        photo.
    }
}
