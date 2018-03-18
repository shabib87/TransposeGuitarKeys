//
//  ViewController.swift
//  Key Transpose
//
//  Created by Ahmad Shabibul Hossain on 2/5/18.
//  Copyright © 2018 Ahmad Shabibul Hossain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let allMajorKeys = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"]
    private let allMinorKeys = ["Am", "A#m", "Bm", "Cm", "C#m", "Dm", "D#m", "Em", "Fm", "F#m", "Gm", "G#m"]
    
    fileprivate var selectedKeyIndex = 0
    
    @IBOutlet private var inputKeyField: UITextField!
    @IBOutlet private var majorPicker: UIPickerView!
    @IBOutlet private var majorKeyInputView: UIView!
    @IBOutlet private var majorFieldBar: UIToolbar!
    @IBOutlet private var majorKeySwitch: UISwitch!
    @IBOutlet private var chordProgressionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputKeyField.inputView = majorKeyInputView
        inputKeyField.inputAccessoryView = majorFieldBar
        inputKeyField.text = "G"
        let keys = transposeNotesForMajorKey(key: "G", transposeBy: 0)
        chordProgressionLabel.text = keys.joined(separator: "\n")
    }
    
    @IBAction private func doneAction(_: Any) {
        let keyIndex = selectedKeyIndex
        let keys:[String]!
        let key: String!
        if majorKeySwitch.isOn {
            key = allMajorKeys[keyIndex]
            keys = transposeNotesForMajorKey(key: key, transposeBy: 0)
        } else {
            key = allMinorKeys[keyIndex]
            keys = transposeNotesForMinorKey(key: key, transposeBy: 0)
        }
        inputKeyField.text = key
        chordProgressionLabel.text = keys.joined(separator: "\n")
        inputKeyField.resignFirstResponder()
    }
    
    @IBAction private func majroSwitchValueChangeAction(_: Any) {
        majorPicker.reloadAllComponents()
    }
    
    private func transposeNotesForMinorKey(key: String, transposeBy step: Int) -> [String] {
        let index = allMinorKeys.index(of: key)!
        
        // all major chords for a key are -2(+10), +3, +8, -5(+7) index of the key in major key array
        let major1 = rotatedIndexForIndex(index: (index + 10 + step))
        let major2 = rotatedIndexForIndex(index: (index + 3 + step))
        let major3 = rotatedIndexForIndex(index: (index + 8 + step))
        let major4 = rotatedIndexForIndex(index: (index + 7 + step))
        
        // all minor chords for a key are +5, +7 index of the key in major key array
        let minor1 = rotatedIndexForIndex(index: (index + step))
        let minor2 = rotatedIndexForIndex(index: (index + 5 + step))
        let minor3 = rotatedIndexForIndex(index: (index + 7 + step))
        
        return [allMinorKeys[minor1],
                allMinorKeys[minor3],
                allMajorKeys[major3],
                allMajorKeys[major1],
                allMajorKeys[major2],
                allMinorKeys[minor2],
                allMajorKeys[major4]]
    }
    
    private func transposeNotesForMajorKey(key: String, transposeBy step: Int) -> [String] {
        let index = allMajorKeys.index(of: key)!
        
        // all major chords for a key are +4, +5, +7 index of the key in major key array
        let major1 = rotatedIndexForIndex(index: (index + step))
        let major2 = rotatedIndexForIndex(index: (index + 5 + step))
        let major3 = rotatedIndexForIndex(index: (index + 7 + step))
        let major4 = rotatedIndexForIndex(index: (index + 4 + step))
        
        // all minor chords for a key are -3(+9), +2, +4 index of the key in major key array
        let minor1 = rotatedIndexForIndex(index: (index + 9 + step))
        let minor2 = rotatedIndexForIndex(index: (index + 2 + step))
        let minor3 = rotatedIndexForIndex(index: (index + 4 + step))
        
        return [allMajorKeys[major1],
                allMinorKeys[minor1],
                allMajorKeys[major2],
                allMajorKeys[major3],
                allMinorKeys[minor2],
                allMinorKeys[minor3],
                allMajorKeys[major4]]
    }
    
    func rotatedIndexForIndex(index: Int) -> Int {
        if index >= allMajorKeys.count {
            return index - allMajorKeys.count
        } else if index < 0 {
            return allMajorKeys.count + index
        }
        return index
    }
}

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allMajorKeys.count
    }
}

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if majorKeySwitch.isOn {
            return allMajorKeys[row]
        } else {
            return allMinorKeys[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedKeyIndex = row
    }
}

