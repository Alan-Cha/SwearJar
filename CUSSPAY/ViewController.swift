//
//  ViewController.swift
//  CUSSPAY
//
//  Created by Hope Jin on 9/17/16.
//  Copyright © 2016 BigRedHacks#3. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet var mainButton: UIButton!
    // @IBOutlet weak var firstNameTextField: UITextField!
    // @IBOutlet weak var lastNameTextField: UITextField!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    let keyWords = ["banana", "donald", "trashcan", "monkey", "dog", "cat"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                        
                    } else {
                        // failed to record!
                        let message = "Failed to record!"
                        let errorM = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Okay", style: .destructive, handler: nil)
                        errorM.addAction(okAction)
                    }
                }
            }
        } catch {
            // failed to record!
            let message = "Failed to record!"
            let errorM = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .destructive, handler: nil)
            errorM.addAction(okAction)
        }
    }
    
    func loadRecordingUI() {
        if let button = mainButton as UIButton! {
            button.setTitle("C", for: .normal)
            button.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
            view.addSubview(mainButton)
        }
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("BASERECORDING.wav")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            mainButton.setTitle("X", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print("DOCUMENT DIRECTORY WAHHHHH \(documentsDirectory)")
        return documentsDirectory
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            mainButton.setTitle("C", for: .normal)
        } else {
            mainButton.setTitle("C", for: .normal)
            let message = "Failed to record!"
            let errorM = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .destructive, handler: nil)
            errorM.addAction(okAction)
        }
    }
    
    func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
}
