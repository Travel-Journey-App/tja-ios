//
//  DatePickerTextField.swift
//  TJA
//
//  Created by Miron Rogovets on 17.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI
import UIKit

class DateTextField: UITextField {
    // MARK: - Public properties
    @Binding var date: Date?

    // MARK: - Initializers
    init(date: Binding<Date?>, mode datePickerMode: UIDatePicker.Mode = .date) {
        self._date = date
        super.init(frame: .zero)
        self.datePickerView.datePickerMode = datePickerMode
        
        if let date = date.wrappedValue {
            self.datePickerView.date = date
        }

        self.datePickerView.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        self.inputView = datePickerView
        
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

    // MARK: - Private properties
    private lazy var datePickerView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        return datePickerView
    }()

    // MARK: - Private methods
    @objc func dateChanged(_ sender: UIDatePicker) {
        self.date = sender.date
    }
    
    @objc private func dismiss() {
        resignFirstResponder()
    }
}

struct DateField: UIViewRepresentable {
    // MARK: - Public properties
    @Binding var date: Date?

    // MARK: - Initializers
    init<S>(
        _ title: S,
        date: Binding<Date?>,
        formatter: DateFormatting = dateFormatter,
        mode datePickerMode: UIDatePicker.Mode = .date
    ) where S: StringProtocol {
        self.placeholder = String(title)
        self._date = date

        self.textField = DateTextField(date: date, mode: datePickerMode)
        self.formatter = formatter
    }

    // MARK: - Public methods
    func makeUIView(context: UIViewRepresentableContext<DateField>) -> UITextField {
        textField.placeholder = placeholder
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<DateField>) {
        if let date = date {
            uiView.text = formatter.string(from: date)
        }
    }

    // MARK: - Private properties
    private var placeholder: String
    private let formatter: DateFormatting
    private let textField: DateTextField
}

struct UnderlinedDateField: View {
    
    @Binding var date: Date?
    let placeholder: String
    let formatter: DateFormatting = dateFormatter
    
    var imageName: String? = nil
    var fontSize: CGFloat = 16
    
    private var hasIcon: Bool {
        return imageName != nil
    }
    
    private var color: Color {
        return date != nil ? Color("MainRed") : Color(UIColor.systemGray)
    }
    
    private var field: some View {
        DateField(placeholder, date: $date, formatter: formatter)
            .font(.system(size: fontSize))
    }
    
    var body: some View {
        VStack {
            HStack {
                field
                Image(systemName: imageName ?? "")
                    .foregroundColor(color)
            }
//            Divider().background(color)
            // Undeline
            Rectangle().fill(color).frame(height: 1)
        }
    }
}

struct DatePickerTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DateField("Date 1", date: .constant(Date()))
                .frame(width: 100, height: 50)
            UnderlinedDateField(date: .constant(nil), placeholder: "Date 2", imageName: "calendar")
                .frame(width: 100, height: 50)
        }
    }
}
