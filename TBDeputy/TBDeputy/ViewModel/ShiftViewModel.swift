//
//  ShiftViewModel.swift
//  TBDeputy
//
//  Created by Tushar on 16/9/18.
//  Copyright © 2018 bole.tushar. All rights reserved.
//

import Foundation

class ShiftViewModel {
    
    static let shared = ShiftViewModel()
    
    var shifts = [ShiftInfo]()
    let apiService = NetworkService()
    
    func getAllShifts(callback:@escaping (_ status : Bool) -> ()) {
        
        apiService.fetchAllShifts { (array, error) in
            
            var status = true
            if error == nil && (array?.count)! > 0 {
                /// Update shifts and save them locally
                self.shifts = array!
                self.saveShiftsLocally()
            } else {
                status = false
                /// In case of error showing user the saved data
                if let data = UserDefaults.standard.value(forKey:"Shifts") as? Data {
                    self.shifts = try! PropertyListDecoder().decode(Array<ShiftInfo>.self, from: data)
                }
            }
            
            callback(status)
        }
    }
    
    func postShiftInfo(info: ShiftInfo, callback:@escaping (_ status : Bool) -> ()) {
        
        apiService.postShiftUpdate(info: info) { (status, error) in
            
            if error == nil && status {
                callback(true)
            } else {
                callback(false)
            }
        }
    }
    
    func saveShiftsLocally() {
        
        //// Saving All shifts locally
        UserDefaults.standard.set(try? PropertyListEncoder().encode(shifts), forKey:"Shifts")
    }
}
