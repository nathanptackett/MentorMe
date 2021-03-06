import FluentMySQL
import Vapor

final class Category: MySQLModel {
	var id: Int?
	var name: String
	
	init(id: Int? = nil, name: String) {
		self.id = id
		self.name = name
	}
}

extension Category: Migration {
	static func prepare(on connection: MySQLConnection) -> Future<Void> {
		return Database.create(self, on: connection) { builder in
			try addProperties(to: builder)
			
			// Mark name field as UNIQUE
			try builder.addIndex(to: \.name, isUnique: true)
		}
	}
}

extension Category: Content { }

extension Category: Parameter { }

extension Category {
	func sampleQuestions() -> Children<Category, SampleQuestion> {
		return children(\SampleQuestion.categoryID)
	}
	
	func mentors() -> Children<Category, Mentor> {
		return children(\Mentor.categoryID)
	}
}

extension Category {
	static func getAll(on conn: DatabaseConnectable) throws -> Future<[Category]> {
		return try query(on: conn).sort(\.id, .ascending).all()
	}
}
