import Fluent
import Vapor

final class User: Model, Content {
    static let schema = ModelSchemas.user.rawValue
   
    init() { }

    @ID(key: .id)
    var id: UUID?

    @Field(key: "first")
    var first: String

    @Field(key: "last")
    var last: String

    @Field(key: "email")
    var email: String
 
    @Field(key: "phone")
    var phone: String

    @Children(for: \.$owner)
    var spaces: [Space] 


    init(id: UUID? = nil, first: String, last: String, email: String, phone: String) {
        self.id = id
        self.first = first
        self.last = last
        self.email = email
        self.phone = phone
    }
}
