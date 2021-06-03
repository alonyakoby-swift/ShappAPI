import Fluent
import Vapor

struct SpaceController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let spaces = routes.grouped("spaces")
        spaces.get(use: index)
        spaces.post(use: create)
        spaces.group(":id") { space in
            space.delete(use: delete)
            space.get(use: findSingleSpace)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Space]> {
    return Space.query(on: req.db).all()
}
    
    func findSingleSpace(req: Request) throws  -> EventLoopFuture<Space> {
        guard let name = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        let space = Space.query(on: req.db)
            .filter(\.$name == name).first()
            .unwrap(or: Abort(.notFound))
        return space
    }

    func create(req: Request) throws -> EventLoopFuture<Space> {
        let space = try req.content.decode(Space.self)
        return space.save(on: req.db).map { space }

    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Space.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
