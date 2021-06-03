import Fluent
import FluentMongoDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    try app.databases.use(.mongo(connectionString: "mongodb://localhost:27017/shappapi"), as: .mongo)
    // register routes
    app.migrations.add(CreateUser())
    app.migrations.add(CreateSpace())
    try routes(app)
}
