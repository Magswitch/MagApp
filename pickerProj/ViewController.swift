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
    
    
/*
///////////// Variables
*/
    
//------Views-
    
    let connectionStatusView = UIView()
    let safetyStatusView = UIView()
    
//------Colors-
    let backgroundTransparencyDown: UIColor = UIColor(red: 0.25, green: 0.0, blue: 0.5, alpha: 0.05)
    let backgroundTransparencyUp: UIColor = UIColor(red: 0.25, green: 0.3, blue: 0.2, alpha: 0.0)
    let blueTransparency: UIColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.15)
    let greenTransparency: UIColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.3)
    let redTransparency: UIColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.4)
    let amberTransparency: UIColor = UIColor(red: 1.0, green: 0.1, blue: 0.0, alpha: 0.3)
    
//------Arrays-
    let toolArray = ["AR15","AR20","AR30","PLAY20x4","PLAY50x2","PLAY50x3","PLAY50x4","PLAY70x2","PLAY70x3","PLAY70x4","E-Drive 50mm", "E-Drive 30mm", "SF600"]
    let valueArray = ["24", "23","22","21","20","19","18","17","16","15","14","13","12","11","10","9","8","7","6","5","4","3","2","1","3/4","1/2","1/4","1/8","1/10"]
    let unitArray = ["inch","gauge","cm", "mm"]
    
    
//------Bluetooth-
    var centralManager : CBCentralManager!
    var sensorTagPeripheral : CBPeripheral!
    var discoveredPeripheral:CBPeripheral?
    
//-------Status-
    var safetyStatus:String = ""
    var connectionStatus: String = ""
    
    
    
/*
///////////// Outlets
*/
    
    @IBOutlet weak var unsafeLabel: UILabel!
    @IBOutlet weak var cautionLabel: UILabel!
    @IBOutlet weak var safeLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var connectedLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!

/*
///////////// Buttons
*/
    // These are just test buttons that should be removed at some point..
    
    @IBAction func Unsafe(sender: AnyObject) {
        
        safetyStatus = "Unsafe"
        safetyBarPositionSwap(getSafetyBarStatus())
        
    }
    @IBAction func connectedButton(sender: AnyObject) {
        
        connectionStatus = "Connected"
        connectedLabel.text = "Okay"
        updateConnectionStatusLabel()
        
        fadeToGreen(connectionStatusView, duration: 0.3)
        slideRight(connectionStatusView, duration: 0.3)
        
        connectionBarPositionSwap(getConnectionStatus())
        safetyBarPositionSwap(getSafetyBarStatus())
        
        
    }
    @IBAction func scanButton(sender: AnyObject) {
      
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
        connectionStatus = "Scanning..."
        connectedLabel.text = "Okay"
        updateConnectionStatusLabel()
        
        UIView.transitionWithView(connectionLabel, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { self.connectionLabel.textColor = self.backgroundTransparencyUp}, completion: nil)
        UIView.transitionWithView(connectedLabel, duration: 1.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { self.connectedLabel.textColor = UIColor.blackColor()}, completion: nil)
        
    }
    
/*
///////////// Status
*/
    
    func getSafetyBarStatus()->String {
        
        return safetyStatus
        
    }
    func getConnectionStatus()->String{
        
        return connectionStatus
        
    }
    func updateConnectionStatusLabel(){
        
        connectionLabel.text = connectionStatus
    }
    
/*
//////////// Transitions
*/
    
    func fadeOutLabel(label: UILabel, duration:NSTimeInterval) {
        
        UIView.transitionWithView(label, duration: duration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {label.textColor = self.backgroundTransparencyUp}, completion: nil)
        
        
    }
    func fadeInLabel(label: UILabel, duration:NSTimeInterval) {
        
       UIView.transitionWithView(label, duration: duration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {label.textColor = UIColor.blackColor()}, completion: nil)
        
    }
    func safetyBarPositionSwap(safetyStatus:String) {
        
        switch safetyStatus {
            
            case "Unsafe":
                
            UIView.animateWithDuration(0.3, animations: {self.safetyStatusView.backgroundColor = self.redTransparency; self.safetyStatusView.frame = CGRect(x: 0, y: 430, width: 190, height: 50)})
            fadeInLabel(unsafeLabel, duration: 1.2)
            fadeOutLabel(cautionLabel, duration: 0.2)
            fadeOutLabel(safeLabel, duration: 0.2)
        
            case "Caution":
            
            UIView.animateWithDuration(0.3, animations: {self.safetyStatusView.backgroundColor = self.amberTransparency; self.safetyStatusView.frame = CGRect(x: 0+95, y: 430, width: 190, height: 50)})
            fadeInLabel(cautionLabel, duration: 1.2)
            fadeOutLabel(unsafeLabel, duration: 0.2)
            fadeOutLabel(safeLabel, duration: 0.2)
            
            
            case "Safe":
            
            UIView.animateWithDuration(0.3, animations: {self.safetyStatusView.backgroundColor = self.greenTransparency; self.safetyStatusView.frame = CGRect(x: 0+190, y: 430, width: 190, height: 50)})
            fadeInLabel(safeLabel, duration: 1.2)
            fadeOutLabel(unsafeLabel, duration: 0.2)
            fadeOutLabel(cautionLabel, duration: 0.2)
            
            default:
            
                return
            
        }
    
    }
    func connectionBarPositionSwap(connection:String) {
        
        if connectionStatus == "Connected" {
            println("connected and good")
            fadeOutLabel(connectionLabel, duration: 0.2)
            fadeInLabel(connectedLabel, duration: 1.2)
        }
        
        else {
            println("reached the else")
            fadeOutLabel(connectedLabel, duration: 0.2)
            fadeInLabel(connectionLabel, duration: 1.2)
        }
        
            
    }
    func slideRight(viewToTransistion: UIView, duration: NSTimeInterval){
        UIView.animateWithDuration(0.3, animations: {viewToTransistion.frame = CGRect(x: 0+190, y: 380, width: 190, height: 50)})
    }
    func fadeToGreen(viewToTransistion: UIView, duration: NSTimeInterval){
        UIView.animateWithDuration(0.3, animations: {viewToTransistion.backgroundColor = self.greenTransparency})
    }

/*
///////////// Bluetooth
*/

    func centralManagerDidUpdateState(central: CBCentralManager!) {
        
        switch centralManager.state {
            
        case .PoweredOff:
            println("Powered Off")
            connectionStatus = "Disconnected"
            updateConnectionStatusLabel()
            break
        case .PoweredOn:
            println("Powered On")
            connectionStatus = "Connected"
            updateConnectionStatusLabel()
            
            self.scanButton(self)
            break
        case .Resetting:
            println("Reseting")
            connectionStatus = "Resetting..."
            updateConnectionStatusLabel()
            break
        case .Unauthorized:
            println("Unauthorized")
            connectionStatus = "Unauthorized"
            updateConnectionStatusLabel()
            break
        case .Unknown:
            println("Unknown")
            connectionStatus = "Unkown"
            updateConnectionStatusLabel()
            break
        case .Unsupported:
            println("Unsupported")
            connectionStatus = "Unsupported"
            updateConnectionStatusLabel()
            break
            
        default:
            break
        }
        
    }
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        var discoveredPeripheral: CBPeripheral
        
    }
    
/*
///////////// PickerView
*/
    
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
    
    
/*
///////////////// event handling
*/
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updateConnectionStatusLabel()
        
        connectionStatusView.backgroundColor = self.blueTransparency
        connectionStatusView.frame = CGRect(x: 0, y: 380, width: 190, height: 50)
        
        safetyStatusView.backgroundColor = self.redTransparency
        safetyStatusView.frame = CGRect(x: 0, y: 430, width: 190, height: 50)
        
        
        
        cautionLabel.textColor = self.backgroundTransparencyUp
        safeLabel.textColor = self.backgroundTransparencyUp
        
       
        self.connectedLabel.text = ""
        
        self.view.addSubview(safetyStatusView)
        self.view.addSubview(connectionStatusView)
        
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
