
import Fluent
import Vapor

final class Space: Model, Content {
    static let schema = ModelSchemas.space.rawValue
   
    init() { }

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Parent(key: "ownerID")
    var owner: User


    init(id: UUID? = nil, name: String, ownerID: UUID) throws {
        self.id = id
        self.name = name
        self.$owner.id = ownerID
    }
}
