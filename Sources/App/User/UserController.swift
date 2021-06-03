import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users") 
        users.get(use: index)
        users.post(use: create)
        users.group(":id") { user in
            user.delete(use: delete)
            user.get(use: findSingleUserID)
        }
        users.group("search",":x") { user in
            user.get(use: findSingleUserOther)
        }
    }

func index(req: Request) throws -> EventLoopFuture<[User]> {
    return User.query(on: req.db)
        .with(\.$spaces)
        .all()
}
    
    func findSingleUserID(req: Request) throws  -> EventLoopFuture<User> {
        return User.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func findSingleUserOther(req: Request) throws  -> EventLoopFuture<[User]> {
        guard let search = req.parameters.get("x") else {
            throw Abort(.badRequest)
        }
        
        return User.query(on: req.db).group(.or) { group in
            group
                .filter(\.$first =~  search)
                .filter(\.$last =~ search)
                .filter(\.$email =~  search)
                .filter(\.$phone =~  search)
        }
        .with(\.$spaces)
        .all()
    }

    func create(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map { user }

    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return User.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
//
//extension UserController {
//    func addSpace(req: Request) throws -> EventLoopFuture<Space> {
//        
//    }
//}
