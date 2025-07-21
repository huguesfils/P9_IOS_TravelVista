import Testing
import Foundation
@testable import TravelVista

struct MockCountryService: CountryServiceProtocol {
    var countriesToReturn: [Country] = []
    func load<T: Decodable>(_ filename: String) -> T {
        if T.self == [Country].self {
            return countriesToReturn as! T
        }
        fatalError("Type non supporté par le mock")
    }
}

struct ServiceTests {
    @Test
    func testLoadCountryFromValidJSON() throws {
        // Given
        let json = """
        [
            {"name": "Canada", "capital": "Ottawa", "description": "Un pays froid", "pictureName": "canada", "coordinates": {"latitude": 45.4215, "longitude": -75.6993}, "rate": 3}
        ]
        """.data(using: .utf8)!
        // When
        let countries = try JSONDecoder().decode([Country].self, from: json)
        // Then
        #expect(countries.count == 1, "Le tableau doit contenir un pays")
        #expect(countries.first?.name == "Canada", "Le nom du pays doit être Canada")
        #expect(countries.first?.capital == "Ottawa", "La capitale doit être Ottawa")
        #expect(countries.first?.rate == 3, "La note doit être 3")
    }

    @Test
    func testLoadCountryFromInvalidJSON() throws {
        // Given
        let json = """
        [
            {"name": "Canada", "capital": 123, "description": "Un pays froid", "pictureName": "canada", "coordinates": {"latitude": 45.4215, "longitude": -75.6993}, "rate": 3}
        ]
        """.data(using: .utf8)!
        var didCatch = false
        // When & Then
        do {
            _ = try JSONDecoder().decode([Country].self, from: json)
            #expect(Bool(false), "Le décodage aurait dû échouer à cause d'un mauvais type pour 'capital'")
        } catch {
            didCatch = true
        }
        #expect(didCatch, "Le bloc catch doit être exécuté pour un JSON invalide")
    }

    @Test
    func testServiceLoadWithMock() throws {
        // Given
        let mockCountries = [
            Country(name: "MockLand", capital: "MockCity", description: "desc", rate: 5, pictureName: "mock", coordinates: .init(latitude: 0, longitude: 0))
        ]
        let mockService = MockCountryService(countriesToReturn: mockCountries)
        // When
        let countries: [Country] = mockService.load("nimportequoi.json")
        // Then
        #expect(countries.count == 1)
        #expect(countries.first?.name == "MockLand")
        #expect(countries.first?.capital == "MockCity")
        #expect(countries.first?.rate == 5)
    }
}
