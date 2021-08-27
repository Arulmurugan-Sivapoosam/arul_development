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

typealias PermissionBuilder = DPArrayBuilder<Access>
typealias ArticleBuilder = DPArrayBuilder<Article>

@resultBuilder struct DPArrayBuilder<InputType> {

  typealias Components = [InputType]

  static func buildBlock(_ components: Components...) -> Components {
    buildArray(components)
  }

  static func buildEither(first component: Components) -> Components {
    component
  }

  static func buildEither(second component: Components) -> Components {
    component
  }

  static func buildOptional(_ component: Components?) -> Components {
    component ?? []
  }

  static func buildArray(_ components: [Components]) -> Components {
    components.flatMap {$0}
  }

  static func buildExpression(_ expression: InputType) -> Components {
    [expression]
  }

  static func buildExpression(_ expression: InputType?) -> Components {
    expression.map { [$0] } ?? []
  }

}
