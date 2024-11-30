import AppIntents
import SwiftUI

struct MetroQuery: EntityQuery {
    func entities(for identifies: [Estacion.ID]) async throws -> [Estacion]{
        Estacion.allEstaciones.filter {
            identifies.contains($0.id)
        }
    }
    
    func suggestedEntities() async throws -> [Estacion] {
        Estacion.allEstaciones
    }
        
    func defaultResult() async -> Estacion? {
        Estacion.allEstaciones.first
    }    
}

struct Estacion: AppEntity {
    var id: String
    var nombre: String

    // Representación para AppEntity
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Estación de Metro"
    }
    
    static var defaultQuery = MetroQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(nombre)")
    }

    // Mock Data
    static let allEstaciones: [Estacion] = [
        Estacion(id: "BSR", nombre: "Basauri"),
        Estacion(id: "ETX", nombre: "Etxebarri"),
        Estacion(id: "SAM", nombre: "Santimami/San Mamés"),
        Estacion(id: "ANS", nombre: "Ansio"),
        Estacion(id: "URB", nombre: "Urbinaga"),
        Estacion(id: "KAB", nombre: "Kabiezes"),
        Estacion(id: "PEN", nombre: "Peñota"),
        Estacion(id: "BOL", nombre: "Bolueta"),
        Estacion(id: "BAS", nombre: "Basarrate"),
        Estacion(id: "SAN", nombre: "Santutxu"),
        Estacion(id: "SAR", nombre: "Sarriko"),
        Estacion(id: "SOP", nombre: "Sopela"),
        Estacion(id: "POR", nombre: "Portugalete"),
        Estacion(id: "LAM", nombre: "Lamiako"),
        Estacion(id: "ARE", nombre: "Areeta"),
        Estacion(id: "NEG", nombre: "Neguri"),
        Estacion(id: "SES", nombre: "Sestao"),
        Estacion(id: "AST", nombre: "Astrabudua"),
        Estacion(id: "LEI", nombre: "Leioa"),
        Estacion(id: "ALG", nombre: "Algorta"),
        Estacion(id: "URD", nombre: "Urduliz"),
        Estacion(id: "BAG", nombre: "Bagatza"),
        Estacion(id: "CAV", nombre: "Zazpikaleak/Casco Viejo"),
        Estacion(id: "SIN", nombre: "San Ignazio"),
        Estacion(id: "AIB", nombre: "Aiboa"),
        Estacion(id: "GUR", nombre: "Gurutzeta/Cruces"),
        Estacion(id: "STZ", nombre: "Santurtzi"),
        Estacion(id: "ABT", nombre: "Abatxolo"),
        Estacion(id: "IND", nombre: "Indautxu"),
        Estacion(id: "GOB", nombre: "Gobela"),
        Estacion(id: "BID", nombre: "Bidezabal"),
        Estacion(id: "IBB", nombre: "Ibarbengoa"),
        Estacion(id: "LAR", nombre: "Larrabasterra"),
        Estacion(id: "PLE", nombre: "Plentzia"),
        Estacion(id: "ARZ", nombre: "Ariz"),
        Estacion(id: "DEU", nombre: "Deustu"),
        Estacion(id: "BER", nombre: "Berango"),
        Estacion(id: "ABA", nombre: "Abando"),
        Estacion(id: "MOY", nombre: "Moyua"),
        Estacion(id: "LUT", nombre: "Lutxana"),
        Estacion(id: "ERA", nombre: "Erandio"),
        Estacion(id: "BAR", nombre: "Barakaldo")
    ].sorted { $0.nombre < $1.nombre }
}
