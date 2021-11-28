//
//  AddFruitViewController.swift
//  muranakaKadai14
//
//  Created by 村中令 on 2021/11/10.
//

import UIKit

class AddFruitViewController: UIViewController {
    enum Mode {
        case add
        case edit(Fruit)
    }

    enum Result {
        case save(String)
        case cancel
    }

    var mode: Mode?

    @IBOutlet weak private var fruitTextField: UITextField!

    private var result: Result?

    var onSave: (Result) -> Void = { _ in }

    override func viewDidLoad() {
        super.viewDidLoad()
        switch mode {
        case .add:
            break
        case .edit(let fruit):
            fruitTextField.text = fruit.name
        case .none:
            break
        }
    }

    @IBAction private func saveFruit(_ sender: Any) {
        result = .save(fruitTextField.text ?? "")
        guard let result = result else { return }
        onSave(result)
        performSegue(withIdentifier: "SaveSegue", sender: nil)
    }

    @IBAction private func cancel(_ sender: Any) {
        result = .cancel
        guard let result = result else { return }
        onSave(result)
        performSegue(withIdentifier: "CancelSegue", sender: nil)
    }
}
