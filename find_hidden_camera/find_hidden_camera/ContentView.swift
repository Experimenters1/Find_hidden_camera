//
//  ContentView.swift
//  find_hidden_camera
//
//  Created by Huy vu on 12/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var bleScanner = BLEScanner()

        var body: some View {
            VStack {
                Button(action: {
                    bleScanner.startScanning()
                }) {
                    Text("Start Scanning for Hidden Cameras")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                List(bleScanner.devices, id: \.name) { device in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(device.name)
                                .font(.headline)
                            Text("RSSI: \(device.rssi)")
                                .font(.subheadline)
                        }
                        Spacer()
                        Text("Suspicion: \(device.suspicionLevel)%")
                            .font(.body)
                            .foregroundColor(device.suspicionLevel >= 0 ? .red : .orange)
                    }
                }

                Spacer()
            }
            .padding()
        }
}

#Preview {
    ContentView()
}
