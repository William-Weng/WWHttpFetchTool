//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2026/6/3.
//

import UIKit
import WWHttpFetchTool

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetch(url: "https://raw.githubusercontent.com/William-Weng/WWHttpFetchTool/refs/heads/main/LICENSE")
    }
}

extension ViewController {
    
    func fetch(url: String) {

        let tool = WWHttpFetchTool()
        let arguments = WWHttpFetchTool.Arguments(url: url, method: "GET", mode: "text", headers: [])

        Task {
            do {
                let result = try await tool.call(arguments: arguments)
                print(result.first ?? "")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
