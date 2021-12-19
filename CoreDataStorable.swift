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
    switch object(with: predicate) {
    case let .success(matchedObject):
      matchedObject[keyPath: keyPath] = value
      // save your context here...
    case .failure:
      print("Failed to update value")
    }
  }
  
  func objects(with predicate: NSPredicate) -> Result<[CoreDataType], Error> {
    let fetchRequest = NSFetchRequest<CoreDataType>(entityName: entityName)
    fetchRequest.predicate = predicate
    do {
      return try .success(context.fetch(fetchRequest))
    }
    catch let error {
      return .failure(error)
    }
  }
  
  func dataModels(with predicate: NSPredicate, transform: (CoreDataType) -> DataModelType) -> Result<[DataModelType], Error> {
    switch objects(with: predicate) {
    case let .success(coreDataObjects):
      return .success(coreDataObjects.map{transform($0)})
    case let .failure(error):
      return .failure(error)
    }
  }
  
  func object(with predicate: NSPredicate) -> Result<CoreDataType, Error> {
    objects(with: predicate).first
  }
  
  func dataModel(with predicate: NSPredicate, transform: (CoreDataType) -> DataModelType) -> Result<DataModelType, Error> {
    dataModels(with: predicate, transform: transform).first
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
//ArticleList screen.
class Article: NSManagedObject {
  var id: String?
  var title: String?
  var author: String?
}

class ArticleListScreen: CoreDataStorable {
  
  typealias CoreDataType = Article
  
  func renderArticles(writtenBy authorName: String) {
    switch objects(with: NSPredicate(format: "author=%@", authorName)) {
    case let .success(articles):
      // render you article here
      break
    case .failure:
      print("Error occured while fetching articles.")
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


//Article Detail screen.
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
    switch dataModel(with: NSPredicate(format: "id=%@", article.id!), transform: {.init(article: article, content: $0.content)}) {
    case let .success(detailModel):
      render(articleDetail: detailModel)
    case .failure:
      print("Error while fetching articleDetail")
    }
  }
  
  func render(articleDetail: ArticleDetailModel) {
    //....
  }
  
}
