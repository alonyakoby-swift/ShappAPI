import Fluent

struct CreateSpace: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(ModelSchemas.space.rawValue)
            .id()
            .field("name", .string, .required)
            .field("ownerID", .uuid, .required, .references(User.schema, .id))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("spaces").delete()
    }
}
