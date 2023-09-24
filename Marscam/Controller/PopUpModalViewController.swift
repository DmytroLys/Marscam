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
}

public final class PopUpModalViewController: UIViewController {
    
    // MARK: - Properties
    
    public weak var delegate: PopUpModalDelegate?
    public var context: PickerContext?
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
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
            pickerView.reloadAllComponents()
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
        pickerView.delegate = self
        pickerView.dataSource = self
        setupViews()
    }
    
    // MARK: - Methods
    
    public static func create(delegate: PopUpModalDelegate) -> PopUpModalViewController {
        let view = PopUpModalViewController(delegate: delegate)
        return view
    }
    
    @discardableResult
    static public func present(initialView: UIViewController, delegate: PopUpModalDelegate) -> PopUpModalViewController {
        let view = PopUpModalViewController.create(delegate: delegate)
        view.modalPresentationStyle = .overFullScreen
        view.modalTransitionStyle = .coverVertical
        initialView.present(view, animated: true)
        return view
    }
    
    @objc func didTapCancel(_ btn: UIButton) {
        self.delegate?.didTapCancel()
    }
    
    @objc func didTapOK() {
        let selectedValue = pickerData[pickerView.selectedRow(inComponent: 0)]
            delegate?.didTapAccept(selectedValue: selectedValue, context: context)
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
        canvas.addSubview(pickerView)
        canvas.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            canvas.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            canvas.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            canvas.widthAnchor.constraint(equalToConstant: self.view.bounds.width ),
            canvas.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.35),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.widthAnchor.constraint(equalToConstant: 44),
            cancelButton.topAnchor.constraint(equalTo: canvas.topAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: canvas.leadingAnchor, constant: 20),
            applyButton.heightAnchor.constraint(equalToConstant: 44),
            applyButton.widthAnchor.constraint(equalToConstant: 44),
            applyButton.topAnchor.constraint(equalTo: canvas.topAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: canvas.trailingAnchor, constant: -20),
            pickerView.topAnchor.constraint(equalTo: canvas.topAnchor, constant: 60),
            pickerView.leftAnchor.constraint(equalTo: canvas.leftAnchor, constant: 20),
            pickerView.rightAnchor.constraint(equalTo: canvas.rightAnchor, constant: -20),
            pickerView.bottomAnchor.constraint(equalTo: canvas.bottomAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: canvas.topAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: canvas.centerXAnchor)
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
