//
//  ContentView.swift
//  test1
//
//  Created by Huy vu on 3/11/24.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
   @ObservedObject var bleScanner = BLEScanner()
    
    
    var body: some View {
        NavigationView {
            List(bleScanner.discoveredDevices, id: \.id) { device in
                VStack(alignment: .leading) {
                    Text("Tên thiết bị: \(device.name)")
                        .font(.headline)
                    Text("RSSI: \(device.rssi)")
                        .font(.subheadline)
                }
            }
            .navigationTitle("Quét BLE Camera Ẩn")
            .onAppear {
                bleScanner.startScanning()
            }
            .onDisappear {
                bleScanner.stopScanning()
            }
        }
    }
}

#Preview {
    ContentView()
}
