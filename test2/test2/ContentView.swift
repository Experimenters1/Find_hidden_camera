//
//  ContentView.swift
//  test2
//
//  Created by Huy vu on 3/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var bleScanner = BLEScanner()
    
    var body: some View {
        VStack {
            Button(action: {
                bleScanner.startScanning()
                        }) {
                            Text("Find hidden Camera")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
        }
        .padding()
        .onAppear(){
            let uuid = UUID().uuidString // Tạo một UUID mới và lấy giá trị chuỗi
            print("UUID là giá trị là gì : ",uuid)
        }
    }
}

#Preview {
    ContentView()
}
