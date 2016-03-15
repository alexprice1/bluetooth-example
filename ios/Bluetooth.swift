import CoreBluetooth
var characteristicUUIDString = "BROADCASTED_UUID"
var characteristicUUID = CBUUID(string: characteristicUUIDString)

@objc(Bluetooth)
class Bluetooth: NSObject {
  
  var bleManager: BLEManager = BLEManager()
  @objc func sendMessage(message: String!) -> Void {
    if let unwrappedMessage = message {
      bleManager.sendMessage(unwrappedMessage);
    }
  }
  
  @objc func reconnect() -> Void {
    bleManager.reconnect();
  }
  
}

class BLEManager : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate  {
  var serviceUUIDs = [CBUUID(string: "SERVICE_UUID")]
  var centralManager : CBCentralManager!
  var sensorTagPeripheral : CBPeripheral!
  var characteristic: CBCharacteristic!
  var messageQueue: [String] = []
  var peripheralName = "Name Of Bluetooth Device"
  
  override init() {
    super.init()
    self.centralManager = CBCentralManager(delegate: self, queue: nil)
  }
  
  func reconnect() {
    self.sensorTagPeripheral = nil;
    self.centralManager.scanForPeripheralsWithServices(serviceUUIDs, options: nil)
  }
  
  func sendMessage(message: String) {
    self.messageQueue.append(message)
    tryToSendMessages()
//    reconnect()
  }
  
  func tryToSendMessages() {
    if self.sensorTagPeripheral == nil || self.characteristic == nil {
      return
    }
    
    let perpherials = self.centralManager.retrieveConnectedPeripheralsWithServices(serviceUUIDs)
    if perpherials.count ==  0 {
      return reconnect()
    }
    let connectedPeripheral = perpherials[0]
    
    for message in self.messageQueue {
      let data: NSData = message.dataUsingEncoding(NSUTF8StringEncoding)!
      connectedPeripheral.writeValue(data, forCharacteristic: self.characteristic, type: CBCharacteristicWriteType.WithResponse)
    }
    
    messageQueue = []
  }
  
  func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
    
    if let peripheralName = peripheral.name {
      if peripheralName == self.peripheralName {
        self.sensorTagPeripheral = peripheral
        self.sensorTagPeripheral.delegate = self
        central.stopScan()
        central.connectPeripheral(peripheral, options: [ CBConnectPeripheralOptionNotifyOnNotificationKey: true ])
      }
    }
  }
  
  func centralManager(central: CBCentralManager,
    didConnectPeripheral peripheral: CBPeripheral) {
      peripheral.discoverServices(nil)
  }
  
  func centralManager(central: CBCentralManager,
    didFailToConnectPeripheral peripheral: CBPeripheral,
    error: NSError?) {
      print("failed connected")
  }
  
  func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error :NSError?) {
    //do something with did write, callback?
  }
  
  func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
    for service in peripheral.services! {
      let thisService = service as CBService
      peripheral.discoverCharacteristics(nil, forService: thisService)
    }
  }
  
  // Enable notification and sensor for each characteristic of valid service
  func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
    for charateristic in service.characteristics! {
      let thisCharacteristic = charateristic as CBCharacteristic
      if(thisCharacteristic.UUID == characteristicUUID) {
        
        self.characteristic = thisCharacteristic;
        tryToSendMessages()
      }
    }
    
  }
  
  func centralManagerDidUpdateState(central: CBCentralManager) {
    switch(central.state) {
    case .Unsupported:
      print("Unsupported")
    case .Unauthorized:
      print("Unauthorized")
    case .Unknown:
      print("Unknown")
    case .Resetting:
      print("Resetting")
    case .PoweredOff:
      print("PoweredOff")
    case .PoweredOn:
      central.scanForPeripheralsWithServices(serviceUUIDs, options: nil)
    }
  }
}