//
//  BLEDevice.swift
//  test1
//
//  Created by Huy vu on 3/11/24.
//

import Foundation

struct BLEDevice: Identifiable {
    let id: UUID
    let name: String
    var rssi: Int
}
