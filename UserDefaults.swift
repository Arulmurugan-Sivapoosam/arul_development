import Foundation

//BlogLink: https://swiftdevelopers.tech/remove-userdefaults-boilerplate-code-using-propertywrapper-5e225f238fec

class Article {
  @UserDefault(key: "Article_name") var name: String = ""
  @UserDefault(key: "Article_ID") var id: Int = .zero
}

@propertyWrapper
struct UserDefault<ValueType> {
  let key: String
  let defaultValue: ValueType
  
  init(wrappedValue: ValueType, key: String) {
    self.key = key
    self.defaultValue = wrappedValue
  }
  
  var wrappedValue: ValueType {
    get { (UserDefaults.standard.value(forKey: key) as? ValueType) ?? defaultValue }
    set { UserDefaults.standard.set(newValue, forKey: key) }
  }
  
}
