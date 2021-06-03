import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users")
            .id()
            .field("first", .string, .required)
            .field("last", .string, .required)
            .field("email", .string, .required)
            .field("phone", .string, .required)
            .field("owner_id", .uuid, .required, .references("spaces", "id"))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users").delete()
    }
}
