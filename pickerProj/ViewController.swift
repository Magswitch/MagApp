//
//  ViewController.swift
//  pickerProj
//
//  Created by a_dog on 6/8/15.
//  Copyright (c) 2015 a_dog. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    
                    ///////////////
    ///////////////// Variables  ////////////////////////////////
    
    
    let connectButtonView = UIView()
    let safteyButtonView = UIView()
    
    var backgroundTransparencyDown: UIColor = UIColor(red: 0.25, green: 0.0, blue: 0.5, alpha: 0.05)
    var backgroundTransparencyUp: UIColor = UIColor(red: 0.25, green: 0.3, blue: 0.2, alpha: 0.0)
    var blueTransparency: UIColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.15)
    var greenTransparency: UIColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2)
    var redTransparency: UIColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
  
    let toolArray = ["AR15", "AR20", "AR30","PLAY 20x4","PLAY 50x2","PLAY 50x3","PLAY 50x4", "PLAY 70x2", "PLAY 70x3","PLAY70x4","E-Drive 50mm", "E-Drive 30mm", "SF600"]
    let valueArray = ["24", "23","22","21","20","19","18","17","16","15","14","13","12","11","10","9","8","7","6","5","4","3","2","1","7/8","3/4","1/2","1/4","1/8","1/10"]
    let unitArray = ["Gauge", "cm", "mm", "in"]
    
    var connectionStatus: String = ""
    
    var centralManager : CBCentralManager!
    var sensorTagPeripheral : CBPeripheral!
    var discoveredPeripheral:CBPeripheral?
    
    
    
    
    
    
    
                     ///////////
    ///////////////// Outlets //////////////////////////////////////
    
    @IBOutlet weak var littleLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var connectedLabel: UILabel!
    
    @IBAction func thirdButton(sender: AnyObject) {
        
        
    }
    
    func updateConnectionStatus(){
        
        connectionLabel.text = connectionStatus
    }
    
   
    
    @IBAction func refreshButtonRelease(sender: AnyObject) {
        
        littleLabel.text = "Unsafe"
        
        updateConnectionStatus()
        UIView.animateWithDuration(0.3, animations: {self.connectButtonView.backgroundColor = self.blueTransparency; self.connectButtonView.frame = CGRect(x: 0, y: 380, width: 190, height: 50)})
        
        UIView.transitionWithView(connectionLabel, duration: 1.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { self.connectionLabel.textColor = UIColor.blackColor()}, completion: nil)
         UIView.transitionWithView(connectedLabel, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { self.connectedLabel.textColor = self.backgroundTransparencyUp}, completion: nil)
        
    }
    
    
    @IBAction func scanButton(sender: AnyObject) {
        littleLabel.text = "Safe "
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
        connectionStatus = "Scanning..."
        connectedLabel.text = "Okay"
        updateConnectionStatus()
        
        
        UIView.animateWithDuration(0.3, animations: {self.connectButtonView.backgroundColor = self.greenTransparency; self.connectButtonView.frame = CGRect(x: 0+190, y: 380, width: 190, height: 50)})
        
        UIView.transitionWithView(connectionLabel, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { self.connectionLabel.textColor = self.backgroundTransparencyUp}, completion: nil)
        UIView.transitionWithView(connectedLabel, duration: 1.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { self.connectedLabel.textColor = UIColor.blackColor()}, completion: nil)
        
    }
    
    
    
                   ///////////////////////
    /////////////// Bluetooth Management ////////////////////////////////////
    
    
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        
        switch centralManager.state {
            
        case .PoweredOff:
            println("Powered OFF")
            connectionStatus = "Powered Off"
            updateConnectionStatus()
            break
        case .PoweredOn:
            println("ON")
            connectionStatus = "Connected"
            updateConnectionStatus()
           
            self.scanButton(self)
            break
        case .Resetting:
            println("Reset")
            connectionStatus = "Resetting..."
            updateConnectionStatus()
            break
        case .Unauthorized:
            println("Unauthorized")
            connectionStatus = "Unauthorized"
            updateConnectionStatus()
            break
        case .Unknown:
            println("Unknown")
            connectionStatus = "Unkown"
            updateConnectionStatus()
            break
        case .Unsupported:
            println("Unsupported")
            connectionStatus = "Unsupported"
            updateConnectionStatus()
            break
            
        default:
            break
        }
        
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        var discoveredPeripheral: CBPeripheral
        
        
    }
    
                  ////////////////////////////
    /////////////// PickerView Functionality /////////////////////////////////
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }

    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        
        switch component {
        case 0:
            return 160
            
        case 1:
            return 75
            
        case 2:
            return 80
            
        default:
            return 100
            
            
        }
        
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return toolArray.count
            
        case 1:
            return valueArray.count
            
        case 2:
            return unitArray.count
            
        default:
            return valueArray.count
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        switch component {
        case 0:
            return toolArray[row]
            
        case 1:
            return valueArray[row]
            
        case 2:
            return unitArray[row]
            
        default:
            return valueArray[row]
        
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        connectButtonView.backgroundColor = self.blueTransparency
        connectButtonView.frame = CGRect(x: 0, y: 380, width: 190, height: 50)
        
        safteyButtonView.backgroundColor = self.redTransparency
        safteyButtonView.frame = CGRect(x: 0, y: 430, width: 190, height: 50)
        
        littleLabel.text = connectionStatus
        self.connectedLabel.text = ""
        
        self.view.addSubview(connectButtonView)
        self.view.addSubview(safteyButtonView)
        
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
      
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

