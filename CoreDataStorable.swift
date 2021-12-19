import Foundation
import CoreData

protocol CoreDataStorable {
  associatedtype CoreDataType: NSManagedObject
  associatedtype DataModelType = CoreDataType
  var context: NSManagedObjectContext {get}
}

enum CoreDataError: Error {
  case nothingFound
}

extension CoreDataStorable {
  
  var context: NSManagedObjectContext { .init(concurrencyType: .mainQueueConcurrencyType) }// return you context here}
  private var entityName: String { CoreDataType.entity().name ?? "\(CoreDataType.self)"}
  
  func insertNewEntity() -> CoreDataType? {
    NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? CoreDataType
  }
  
  func deleteItems(with predicate: NSPredicate) {
    //
  }
  
  func update<ValueType>(_ keyPath: ReferenceWritableKeyPath<CoreDataType, ValueType>, value: ValueType, where predicate: NSPredicate) {
    do {
      let matchedObject = try object(with: predicate)
      matchedObject[keyPath: keyPath] = value
      // save your context here...
    } catch let error {
      print("Error: \(error.localizedDescription)")
    }
  }
  
  func objects(with predicate: NSPredicate) throws -> [CoreDataType] {
    let fetchRequest = NSFetchRequest<CoreDataType>(entityName: entityName)
    fetchRequest.predicate = predicate
    return try context.fetch(fetchRequest)
  }
  
  func dataModels(with predicate: NSPredicate, transform: (CoreDataType) -> DataModelType) throws -> [DataModelType] {
    try objects(with: predicate).map{transform($0)}
  }
  
  func object(with predicate: NSPredicate) throws -> CoreDataType {
    guard let firstEntity = try objects(with: predicate).first else{throw CoreDataError.nothingFound}
    return firstEntity
  }
  
  func dataModel(with predicate: NSPredicate, transform: (CoreDataType) -> DataModelType) throws -> DataModelType {
    guard let firstEntity = try dataModels(with: predicate, transform: transform).first else{throw CoreDataError.nothingFound}
    return firstEntity
  }
  
}

extension Result where Success: Collection {
  var first: Result<Success.Element, Error> {
    switch self {
    case .success(let success):
      if let firstElement = success.first {
        return .success(firstElement)
      } else {
        return .failure(CoreDataError.nothingFound)
      }
    case let .failure(error):
      return .failure(error)
    }
  }
}

//Implementations
class Article: NSManagedObject {
  var id: String?
  var title: String?
  var author: String?
}

class ArticleListScreen: CoreDataStorable {
  
  typealias CoreDataType = Article
  
  func renderArticles(writtenBy authorName: String) {
    do {
      let articleList = try objects(with: NSPredicate(format: "author=%@", authorName))
      // ....
    } catch let error {
      print("Error: \(error.localizedDescription)")
    }
  }
  
  func addNewArticle() {
    let article = insertNewEntity()
    article?.id = ""
    article?.author = ""
    //.....
  }
  
  func update(articleTitle: String) {
    update(\.title, value: articleTitle, where: NSPredicate(format: "id=%@", "{articleId}"))
  }
  
}


class ArticleDetail: NSManagedObject {
  var id: String?
  var title: String?
  var author: String?
  var content: String?
}

struct ArticleDetailModel {
  var article: Article
  var content: String?
}

class ArticleDetailScreen: CoreDataStorable {
  
  typealias CoreDataType = ArticleDetail
  typealias DataModelType = ArticleDetailModel
  private var article: Article
  
  init(article: Article) {
    self.article = article
  }
  
  func fetchArticleDetail() {
    do {
      let articleDetailModel = try dataModel(with: NSPredicate(format: "id=%@", article.id!), transform: {.init(article: article, content: $0.content)})
      //....
    } catch let error {
      print("Error: \(error.localizedDescription)")
    }
  }
  
  func render(articleDetail: ArticleDetailModel) {
    //....
  }
  
}

