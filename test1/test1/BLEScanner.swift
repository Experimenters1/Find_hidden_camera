//
//  BLEScanner.swift
//  test1
//
//  Created by Huy vu on 3/11/24.
//

import Foundation
import CoreBluetooth


class BLEScanner: NSObject, ObservableObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager!
    @Published var discoveredDevices: [BLEDevice] = []
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        discoveredDevices = []
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        } else {
            print("Bluetooth chưa được bật hoặc không khả dụng.")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let name = peripheral.name, RSSI.intValue != 0 else {
            print("Peripheral name is nil or RSSI is 0. Peripheral: \(peripheral), RSSI: \(RSSI)")
            print("Thiết bị không hợp lệ. Tên thiết bị không có hoặc cường độ tín hiệu quá yếu. \nThông tin thiết bị: \(peripheral), Cường độ tín hiệu (RSSI): \(RSSI)")
                   return
            return
        }
        
        let device = BLEDevice(id: peripheral.identifier, name: name, rssi: RSSI.intValue)
        
        if !discoveredDevices.contains(where: { $0.id == device.id }) {
            discoveredDevices.append(device)
        } else if let index = discoveredDevices.firstIndex(where: { $0.id == device.id }) {
            discoveredDevices[index].rssi = RSSI.intValue
        }
        
        // Cập nhật danh sách thiết bị đã phát hiện
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    
}
