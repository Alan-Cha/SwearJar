//
//  ViewController.swift
//  CUSSPAY
//
//  Created by Hope Jin on 9/17/16.
//  Copyright © 2016 BigRedHacks#3. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet var mainButton: UIButton!
    // @IBOutlet weak var firstNameTextField: UITextField!
    // @IBOutlet weak var lastNameTextField: UITextField!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var triggered: [String: String] = [:]
    var ultraTriggered: [String : String] = [:]
    let keyWords = ["banana", "donald", "trashcan", "monkey", "dog", "cat"]
    let trump = "\(getDocumentsDirectory)BASERECORDING.wav"
    var accessToken: String?
    
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
        return documentsDirectory
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        var beam: String?
        
        if success {
            mainButton.setTitle("C", for: .normal)
            //Microsoft Speech to Text API Details
            _ = Alamofire.request("https://oxford-speech.cloudapp.net/token/issueToken",
                                  method: .post,
                                  parameters: [
                                    "grant_type": "client_credentials",
                                    "client_id": "53e8dbb65ad847b4bb1ee373a565fbb0",
                                    "client_secret": "7bb260fd57124ceab7f4a73033100ef7",
                                    "scope": "speech.platform.bing.com" ]
                ).responseJSON { response in
                    if let JSON = response.result.value {
                        
                        let response = JSON as! NSDictionary
                        for (key, value) in response {
                            self.triggered = [key as! String: value as! String]
                        }
                        beam = response.object(forKey: "access_token") as! String?
                        print(beam!)
                        self.accessToken? = beam!
                        _ = Alamofire.upload(self.getDocumentsDirectory().appendingPathComponent("BASERECORDER.wav"),
                                             to: "https://speech.platform.bing.com/recognize?scenarios=websearch&appid=D4D52672-91D7-4C74-8AD8-42B1D98141A5&locale=en-US&version=3.0&format=json&requestid=b2c95ede-97eb-4c88-81e4-80f32d6aee54&instanceid=b2c95ede-97eb-4c88-81e4-80f32d6aee54&device.os=Android", method: .post,
                                             headers: ["Content-Type" : "audio/wav; samplerate=8000; sourcerate=8000; trustsourcerate=false",
                                                       "Host" : "speech.platform.bing.com",
                                                       "Authorization" : "Bearer \(beam!)"]).responseJSON { response in
                                                        print(beam!)
                                                        print(response.result)
                                                        print(response.data)
                                                        print(response.response)
                                                        print(response.request)
                        }
                    }
            }

            print("BEFORE JSON")
            

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
