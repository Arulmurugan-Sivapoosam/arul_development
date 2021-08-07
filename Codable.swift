import Foundation
//Blog link: https://swiftdevelopers.tech/solve-codable-type-mismatch-error-using-property-wrapper-516cf43306f3

enum CodableTypes: Codable {
  case int(Int)
  case string(String)
  case none

  var description: String {
    switch self {
    case let .int(intVal):
      return intVal.description
    case let .string(stringVal):
      return stringVal
    case .none:
      return ""
    }
  }
  
  init(from decoder: Decoder) throws {
    let container = try? decoder.singleValueContainer()
    if let intValue = try? container?.decode(Int.self) {
      self = .int(intValue)
    } else if let stringVal = try? container?.decode(String.self) {
      self = .string(stringVal)
    } else {
      self = .none
    }
  }

}


@propertyWrapper struct StringConvertible: Codable {

  private var decodedItem: CodableTypes

  var wrappedValue: String { decodedItem.description }

  init(from decoder: Decoder) throws {
    let container = try? decoder.singleValueContainer()
    decodedItem = (try? container?.decode(CodableTypes.self)) ?? .none
  }

}


class Student: Codable {
  var name: String
  @StringConvertible var id: String
}

//Multitype parsing
func parse() {
  let json: [String: Any] = ["name": "ArulMurugan", "id": 5555]
  do {
    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    let student = try JSONDecoder().decode(Student.self, from: jsonData)
    print(student.name, student.id)
  }
  catch let error{
    print("error occured \(error)")
  }

}

parse()
