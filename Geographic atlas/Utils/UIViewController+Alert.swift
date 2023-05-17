import UIKit

extension UIViewController {
    func showErrorAlert(with message: String, actionButton: String, actionCompletion: @escaping (() -> Void)) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionButton, style: .default) { _ in
            actionCompletion()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        [action, cancelAction].forEach { alertVC.addAction($0) }
        present(alertVC, animated: true)
    }
}
