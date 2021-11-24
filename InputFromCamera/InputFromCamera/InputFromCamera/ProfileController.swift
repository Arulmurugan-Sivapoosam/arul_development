
import UIKit

final class ProfileController: UIViewController {
  
  @IBOutlet private var phoneNumber: UITextField!
  @IBOutlet private var emailAddress: UITextField!
  @IBOutlet private var address: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareProfileScreenFields()
  }

}


private extension ProfileController {
  
  func prepareProfileScreenFields() {
    navigationItem.title = "Profile"
    addCamInputBarButton(to: phoneNumber)
    addCamInputBarButton(to: address)
    addCamInputBarButton(to: emailAddress)
  }
  
  func addCamInputBarButton(to field: UITextField) {
    let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 44)))
    toolBar.items = [
      UIBarButtonItem(title: nil, image: .init(systemName: "camera.badge.ellipsis"), primaryAction: .captureTextFromCamera(responder: field, identifier: nil), menu: nil),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard)),
    ]
    field.inputAccessoryView = toolBar
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
}


final class SignatureView: UIView, UIKeyInput {
  
  @IBOutlet private var signature: UILabel!
  @IBOutlet private var cameraButton: UIButton!
  var hasText: Bool { false }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.cornerRadius = 20
    cameraButton.addAction(.captureTextFromCamera(responder: self, identifier: nil), for: .touchUpInside)
  }
  
  func deleteBackward() { }
  
  func insertText(_ text: String) {
    signature.text = text
    cameraButton.isHidden = true
  }
  
}
