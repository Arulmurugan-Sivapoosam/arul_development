import Foundation

enum Access {
  case view, edit, delete, share, all
}

let hasAdminAccess: Bool = true
let canShare: Bool = true
let canDelete: Bool = false
let canLoadVariousAuthorsArticle: Bool = true

class Article {
  
  var name: String
  var author: String
  var Access: [Access]
  
  init(name: String, author: String, @PermissionBuilder Access: () -> [Access]) {
    self.name = name
    self.author = author
    self.Access = Access()
  }
  
  init(name: String, author: String, Access: [Access]) {
    self.name = name
    self.author = author
    self.Access = Access
  }
  
}

// MARK: - Article loading

@ArticleBuilder
func loadArticlesUsingDSL() -> [Article] {
  
  Article(name: "Solve Codable type mismatch error using property wrapper", author: "ArulMurugan") {
    Access.view
    if canShare {
      Access.share
    }
  }
  
  Article(name: "Reduce memory footprint while using UIImage.", author: "ArulMurugan") {
    if hasAdminAccess {
      Access.all
    } else {
      Access.view
      Access.share
    }
  }
  
  if canLoadVariousAuthorsArticle {
    Article(name: "WWDC 2021", author: "Aravindhan Natarajan") {
      Access.share
    }
  } else {
    Article(name: "Remove UserDefaults boilerPlate code using PropertyWrapper", author: "ArulMurugan") {
      Access.share
    }
  }
  
}

func loadArticles() -> [Article] {

  var permission1: [Access] = [.view]
  if canShare {
    permission1.append(.share)
  }
  let article1 = Article(name: "Solve Codable type mismatch error using property wrapper", author: "ArulMurugan", Access: permission1)

  var permission2: [Access] = []
  if hasAdminAccess {
    permission2.append(.all)
  } else {
    permission2.append(.view)
    permission2.append(.share)
  }
  let article2 = Article(name: "Reduce memory footprint while using UIImage.", author: "ArulMurugan", Access: permission2)

  return [article1, article2]

}

// MARK: - ResultBuilder implementaions. (DSL)

@resultBuilder
struct PermissionBuilder {
  
  static func buildOptional(_ component: [Access]?) -> [Access] {
    component ?? []
  }
  
  static func buildBlock(_ components: [Access]...) -> [Access] {
    components.flatMap{$0}
  }
  
  static func buildExpression(_ expression: Access) -> [Access] {
    [expression]
  }
  
  static func buildEither(second component: [Access]) -> [Access] {
    component
  }
  
  static func buildEither(first component: [Access]) -> [Access] {
    component
  }
  
}

@resultBuilder
struct ArticleBuilder {
  
  static func buildOptional(_ component: [Article]?) -> [Article] {
    component ?? []
  }
  
  static func buildBlock(_ components: [Article]...) -> [Article] {
    components.flatMap{$0}
  }
  
  static func buildExpression(_ expression: Article) -> [Article] {
    [expression]
  }
  
  static func buildEither(second component: [Article]) -> [Article] {
    component
  }
  
  static func buildEither(first component: [Article]) -> [Article] {
    component
  }
  
}
