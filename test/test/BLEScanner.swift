//
//  BLEScanner.swift
//  test
//
//  Created by Huy vu on 3/11/24.
//

import Foundation
import CoreBluetooth


class BLEScanner: NSObject, ObservableObject, CBCentralManagerDelegate {
    var centralManager: CBCentralManager!
    @Published var devices: [(name: String, rssi: Int, suspicionLevel: Int)] = []
    var scanTimer: Timer?
    
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
        //            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        
        // Dừng quét sau 15 giây
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            self.stopScanning()
        }
    }
    
    func stopScanning() {
        print("Stop scanning")
        centralManager.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let deviceName = peripheral.name ?? "Unknown Device"
        let rssiValue = RSSI.intValue
        
        // Tính độ nghi ngờ dựa trên giá trị RSSI (giả định)
        let suspicionLevel = calculateSuspicionLevel(from: rssiValue)
        
        // Kiểm tra nếu thiết bị đã tồn tại trong danh sách
        if !devices.contains(where: { $0.name == deviceName }) {
            devices.append((name: deviceName, rssi: rssiValue, suspicionLevel: suspicionLevel))
        }
        
        // Sắp xếp theo mức độ nghi ngờ từ cao đến thấp
        devices.sort { $0.suspicionLevel > $1.suspicionLevel }
        
        print("Discovered: \(deviceName) - RSSI: \(RSSI) - Suspicion: \(suspicionLevel)%")
        
        // Dừng quét nếu thiết bị trùng lặp được phát hiện
        if devices.count > 0 {
            stopScanning()
        }
        
    }
    
    // Tính toán mức độ nghi ngờ dựa trên giá trị RSSI
       func calculateSuspicionLevel(from rssi: Int) -> Int {
           switch rssi {
           case -50...0:
               return 90 // Mức độ nghi ngờ cao nhất (RSSI mạnh nhất)
           case -70...(-51):
               return 70 // Mức độ nghi ngờ trung bình
           case -90...(-71):
               return 50 // Mức độ nghi ngờ thấp
           default:
               return 30 // Mức độ nghi ngờ rất thấp (RSSI yếu)
           }
       }
    
    
    
    
}
