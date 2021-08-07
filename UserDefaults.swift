import Foundation

//BlogLink: https://swiftdevelopers.tech/remove-userdefaults-boilerplate-code-using-propertywrapper-5e225f238fec

class Article {
  @UserDefault(key: "Article_name", defaultValue: "") var name: String
  @UserDefault(key: "Article_ID", defaultValue: .zero) var id: Int
}

@propertyWrapper
struct UserDefault<ValueType> {
  let key: String
  let defaultValue: ValueType
  
  init(key: String, defaultValue: ValueType) {
    self.key = key
    self.defaultValue = defaultValue
  }
  
  var wrappedValue: ValueType {
    get { (UserDefaults.standard.value(forKey: key) as? ValueType) ?? defaultValue }
    set { UserDefaults.standard.set(newValue, forKey: key) }
  }
  
}
