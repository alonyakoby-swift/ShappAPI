import Fluent
import Vapor

func routes(_ app: Application) throws {
    

    app.get { req in
        return req.view.render("index", ["title": "Hello Vapor!"])
    }
    app.get { req in
        return "It works!"
    }

    app.get("hello", ":name") { req -> String in
        return "Hello, " + req.parameters.get("name")!
    }
    
    try app.register(collection: UserController())
    app.migrations.add(CreateUser())
    try app.register(collection: SpaceController())
    app.migrations.add(CreateSpace())
}
