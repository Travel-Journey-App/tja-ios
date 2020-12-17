//
//  PickerTextField.swift
//  TJA
//
//  Created by Miron Rogovets on 17.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import UIKit
import SwiftUI


class PickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - Public properties
    @Binding var selectedString: String?
    var data: [String]

    // MARK: - Initializers
    init(_ selectedString: Binding<String?>, data: [String]) {
        self._selectedString = selectedString
        self.data = data
        super.init(frame: .zero)

        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismiss))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Picker delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedString = data[row]
    }

    // MARK: - Private properties
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()

    // MARK: - Private methods
    @objc private func dismiss() {
        resignFirstResponder()
    }
}

struct PickerField: UIViewRepresentable {
    
    // MARK: - Public properties
    @Binding var selectedString: String?

    // MARK: - Initializers
    init<S>(_ title: S, selectedString: Binding<String?>, data: [String]) where S: StringProtocol {
        self.placeholder = String(title)
        self._selectedString = selectedString

        self.textField = PickerTextField(selectedString, data: data)
    }

    // MARK: - Public methods
    func makeUIView(context: UIViewRepresentableContext<PickerField>) -> UITextField {
        textField.placeholder = placeholder
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = UIColor(named: "MainRed")
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<PickerField>) {
        if let text = selectedString {
            uiView.text = text
        }
    }

    // MARK: - Private properties
    private var placeholder: String
    private let textField: PickerTextField
}

struct PickerTextField_Previews: PreviewProvider {
    static var previews: some View {
        PickerField("Test", selectedString: .constant(""), data: ["A", "B"])
    }
}
