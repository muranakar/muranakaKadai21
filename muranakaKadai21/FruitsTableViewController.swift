//
//  FruitsTableViewController.swift
//  muranakaKadai13
//
//  Created by 村中令 on 2021/11/08.
//

import UIKit

class FruitsTableViewController: UITableViewController {
    private var fruits: [Fruit] =
    [
        Fruit(name: "りんご", isCheck: false),
        Fruit(name: "みかん", isCheck: true),
        Fruit(name: "バナナ", isCheck: false),
        Fruit(name: "パイナップル", isCheck: true)
    ]

    private let realmRepository = FruitRealmRepository()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: - 追記
        guard let readFruits = realmRepository.read() else{ return }
        fruits = readFruits
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fruits.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath
        ) as! FruitTableViewCell // swiftlint:disable:this force_cast
        cell.configure(fruit: fruits[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fruits[indexPath.row].isCheck.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        

        // MARK: - 追記
        realmRepository.save(fruits: fruits)
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fruits.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            // MARK: - 追記
            realmRepository.save(fruits: fruits)
        }
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue( withIdentifier: "EditSegue", sender: indexPath)
    }

    // MARK: - Segue
    @IBAction private func addFruit(segue: UIStoryboardSegue) {
    }

    @IBAction private func cancel(segue: UIStoryboardSegue) {
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        let nav = segue.destination as! UINavigationController // swiftlint:disable:this force_cast
        let addVC = nav.topViewController as! AddFruitViewController // swiftlint:disable:this force_cast
        switch identifier {
        case "AddSegue":
            addVC.mode = .add
            addVC.onSave = {[weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .save(let name):
                    guard !name.isEmpty else { return }
                    strongSelf.fruits.append(Fruit(name: name, isCheck: false))
                    strongSelf.tableView.insertRows(
                        at: [IndexPath(row: strongSelf.fruits.count - 1, section: 0)],
                        with: .top
                    )
                    // MARK: - 追記
                    strongSelf.realmRepository.save(fruits: strongSelf.fruits)
                case.cancel:
                    break
                }
            }

        case "EditSegue":
            guard let indexPath = sender as? IndexPath else { return }
            addVC.mode = .edit(fruits[indexPath.row])
            addVC.onSave = {[weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .save(let name):
                    guard !name.isEmpty else { return }
                    strongSelf.fruits[indexPath.row].name = name
                    strongSelf.tableView.reloadRows(at: [indexPath], with: .automatic)
                    // MARK: - 追記
                    strongSelf.realmRepository.save(fruits: strongSelf.fruits)
                case.cancel:
                    break
                }
            }
        default:
            break
        }
    }
}
