//
//  CameraVC.swift
//  Ice Cream Tracker
//
//  Created by Christopher Hovey on 4/13/19.
//  Copyright © 2019 Chris Hovey. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraVCDelegate{
    func getImage(img: UIImage)
}

class CameraVC: UIViewController {
    
    @IBOutlet weak var viewTakePhoto: UIView!
    @IBOutlet weak var btnTakePhoto: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var delegate: CameraVCDelegate?
    var isEditingPhoto: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCameraSession()
        setUpDevice()
        setUpInputOutput()
        setUpPreviewLayer()
        startRunningCaptureSession()
        print("viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnTakePhoto.isEnabled = true
        if isEditingPhoto{
            btnSkip.isHidden = true
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func cameraBtnPress(_ sender: AnyObject){
        let settings = AVCapturePhotoSettings()
        print("capture")
        photoOutput?.capturePhoto(with: settings, delegate: self)
        btnTakePhoto.isEnabled = false
    }
    
    @IBAction func exitBtnPress(_ sender: AnyObject){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func skipButtonPress(_ sender: AnyObject){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddVC") as? AddVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
        
//        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{
//            return
//        }
//        let urlPath = String(Date().timeIntervalSince1970)
//        let imageURL = url.appendingPathComponent(urlPath)
        
        if let imgData = photo.fileDataRepresentation(), let image = UIImage(data: imgData){
            
            if let vc = storyboard?.instantiateViewController(withIdentifier: "AddVC") as? AddVC{
                
                if isEditingPhoto{
                    if let delegate = delegate{
                        delegate.getImage(img: image)
                    }
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else{
                    DispatchQueue.main.async {
                        vc.imgToSave = image
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            
//            if let delegate = delegate{
//                delegate.getImage(img: image)
//                dismiss(animated: true, completion: nil)
//            } else{
//                do{
//                    try imgData.write(to: imageURL)
//                    if let vc = storyboard?.instantiateViewController(withIdentifier: "AddVC") as? AddVC{
//                        vc.img = image
//                        vc.urlPath = urlPath
//                        DispatchQueue.main.async {
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                    }
//                } catch{
//                    print("saving image failed")
//                }
//            }
            
            

        }
    }
}
