//
//  BLEScanner.swift
//  test2
//
//  Created by Huy vu on 3/11/24.
//

import Foundation
import CoreBluetooth

class BLEScanner: NSObject, ObservableObject, CBCentralManagerDelegate {
    var centralManager: CBCentralManager!
    @Published var devices: [BLEDevice] = []
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth is on")

        } else {
            print("Bluetooth is not available")
        }
    }
    
    func startScanning() {
        print("Start scanning for BLE devices")
        devices.removeAll() // Clear previous scan results
//                    centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
                    centralManager.scanForPeripherals(withServices: nil, options: nil)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.stopScanning()
        }
    }
    
    func stopScanning() {
        print("Stop scanning")
        centralManager.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Khi phát hiện một thiết bị, in ra tên và RSSI của thiết bị đó
//        print("Phát hiện thiết bị: \(peripheral.name ?? "Unknown") với RSSI: \(RSSI) và peripheral.identifier \(peripheral.identifier)")
        let rssiValue = RSSI.intValue
        let distanceStatus = detectSignalStrength(rssiValue: rssiValue)
        print("Phát hiện thiết bị: \(peripheral.name ?? "Unknown") với RSSI: \(distanceStatus)")
        
        
    }
    
    func detectSignalStrength(rssiValue: Int) -> String {
        switch rssiValue {
        case let x where x >= -30 && x <= -67:
            return "Đang gần"
        case let x where x > -67 && x >= -80:
            return "Đang xa"
        case let x where x < -80:
            return "Rất xa"
        default:
            return "Giá trị không hợp lệ"
        }
    }
}
