//
//  PopUpModalViewController.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 24.09.2023.
//

import UIKit

public protocol PopUpModalDelegate : AnyObject {
    func didTapCancel()
    func didTapAccept(selectedValue: String?, context: PickerContext?)
}

public enum PickerContext {
    case rover
    case camera
    case date
}
public enum ModalStyle {
    case filter
    case date
}

public final class PopUpModalViewController: UIViewController {
    
    // MARK: - Properties
    
    public weak var delegate: PopUpModalDelegate?
    public var context: PickerContext?
    public var modalStyle: ModalStyle = .filter
    
    private lazy var filterPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        return picker
    }()
    
    private lazy var canvas: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 50
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.didTapCancel(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var applyButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapOK), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    public var modalTitle: String? {
        didSet {
            titleLabel.text = modalTitle
        }
    }
    
    public var pickerData: [String] = [] {
        didSet {
            filterPicker.reloadAllComponents()
        }
    }
    
    
    // MARK: - Init
    
    public init(delegate: PopUpModalDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        filterPicker.delegate = self
        filterPicker.dataSource = self
        setupViews()
    }
    
    // MARK: - Methods
    
    public static func create(delegate: PopUpModalDelegate) -> PopUpModalViewController {
        let view = PopUpModalViewController(delegate: delegate)
        return view
    }
    
    @discardableResult
    static public func present(initialView: UIViewController, delegate: PopUpModalDelegate, style: ModalStyle) -> PopUpModalViewController {
        let view = PopUpModalViewController.create(delegate: delegate)
        view.modalStyle = style
        view.modalPresentationStyle = .overFullScreen
        view.modalTransitionStyle = .coverVertical
        initialView.present(view, animated: true)
        return view
    }
    
    @objc func didTapCancel(_ btn: UIButton) {
        self.delegate?.didTapCancel()
    }
    
    @objc func didTapOK() {
        if modalStyle == .filter {
                let selectedValue = pickerData[filterPicker.selectedRow(inComponent: 0)]
                delegate?.didTapAccept(selectedValue: selectedValue, context: context)
            } else if modalStyle == .date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let selectedDate = dateFormatter.string(from: datePicker.date)
                delegate?.didTapAccept(selectedValue: selectedDate, context: .date)
            }
            self.dismiss(animated: true, completion: nil)
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UI Configuration
    
    private func setupViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.addSubview(canvas)
        
        let okImage = UIImage(named: "tick")?.withRenderingMode(.alwaysOriginal)
        let cancelImage = UIImage(named: "closeBlack")?.withRenderingMode(.alwaysOriginal)
        applyButton.setImage(okImage, for: .normal)
        cancelButton.setImage(cancelImage, for: .normal)
        canvas.addSubview(cancelButton)
        canvas.addSubview(applyButton)
        canvas.addSubview(filterPicker)
        canvas.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.widthAnchor.constraint(equalToConstant: 44),
            cancelButton.topAnchor.constraint(equalTo: canvas.topAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: canvas.leadingAnchor, constant: 20),
            applyButton.heightAnchor.constraint(equalToConstant: 44),
            applyButton.widthAnchor.constraint(equalToConstant: 44),
            applyButton.topAnchor.constraint(equalTo: canvas.topAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: canvas.trailingAnchor, constant: -20),
            filterPicker.topAnchor.constraint(equalTo: canvas.topAnchor, constant: 60),
            filterPicker.leftAnchor.constraint(equalTo: canvas.leftAnchor, constant: 20),
            filterPicker.rightAnchor.constraint(equalTo: canvas.rightAnchor, constant: -20),
            filterPicker.bottomAnchor.constraint(equalTo: canvas.bottomAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: canvas.topAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: canvas.centerXAnchor)
        ])
        
        if modalStyle == .date {
            setupDatePickerView()
        } else if modalStyle == .filter {
            setupFilterPickerView()
        }
        
    }
    
    func setupDatePickerView() {
        canvas.addSubview(datePicker)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "en_US")
        
        NSLayoutConstraint.activate([
            canvas.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            canvas.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            canvas.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.9),
            canvas.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.35),
            datePicker.topAnchor.constraint(equalTo: canvas.topAnchor, constant: 60),
            datePicker.leftAnchor.constraint(equalTo: canvas.leftAnchor, constant: 20),
            datePicker.rightAnchor.constraint(equalTo: canvas.rightAnchor, constant: -20),
            datePicker.bottomAnchor.constraint(equalTo: canvas.bottomAnchor, constant: -8),
        ])
    }
    
    func setupFilterPickerView() {
        canvas.addSubview(filterPicker)
        
        NSLayoutConstraint.activate([
            canvas.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            canvas.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            canvas.widthAnchor.constraint(equalToConstant: self.view.bounds.width ),
            canvas.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.35),
            filterPicker.topAnchor.constraint(equalTo: canvas.topAnchor, constant: 60),
            filterPicker.leftAnchor.constraint(equalTo: canvas.leftAnchor, constant: 20),
            filterPicker.rightAnchor.constraint(equalTo: canvas.rightAnchor, constant: -20),
            filterPicker.bottomAnchor.constraint(equalTo: canvas.bottomAnchor, constant: -8),
        ])
        
    }
    
}

// MARK: - Extensions

extension PopUpModalViewController: UIPickerViewDelegate {
}

extension PopUpModalViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}
