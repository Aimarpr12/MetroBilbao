/*
import AppIntents

enum Estacion: String, AppEnum, Identifiable {
    case BSR = "Basauri"
    case ETX = "Etxebarri"
    case SAM = "Santimami/San Mamés"
    case ANS = "Ansio"
    case URB = "Urbinaga"
    case KAB = "Kabiezes"
    case PEN = "Peñota"
    case BOL = "Bolueta"
    case BAS = "Basarrate"
    case SAN = "Santutxu"
    case SAR = "Sarriko"
    case SOP = "Sopela"
    case POR = "Portugalete"
    case LAM = "Lamiako"
    case ARE = "Areeta"
    case NEG = "Neguri"
    case SES = "Sestao"
    case AST = "Astrabudua"
    case LEI = "Leioa"
    case ALG = "Algorta"
    case URD = "Urduliz"
    case BAG = "Bagatza"
    case CAV = "Zazpikaleak/Casco Viejo"
    case SIN = "San Ignazio"
    case AIB = "Aiboa"
    case GUR = "Gurutzeta/Cruces"
    case STZ = "Santurtzi"
    case ABT = "Abatxolo"
    case IND = "Indautxu"
    case GOB = "Gobela"
    case BID = "Bidezabal"
    case IBB = "Ibarbengoa"
    case LAR = "Larrabasterra"
    case PLE = "Plentzia"
    case ARZ = "Ariz"
    case DEU = "Deustu"
    case BER = "Berango"
    case ABA = "Abando"
    case MOY = "Moyua"
    case LUT = "Lutxana"
    case ERA = "Erandio"
    case BAR = "Barakaldo"

    // Conformar a `Identifiable`
    var id: String { self.rawValue }

    // Conformar a `AppEnum`
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Estación"
    }

    static var caseDisplayRepresentations: [Estacion: DisplayRepresentation] {
        [
            .BSR: "Basauri",
            .ETX: "Etxebarri",
            .SAM: "Santimami/San Mamés",
            .ANS: "Ansio",
            .URB: "Urbinaga",
            .KAB: "Kabiezes",
            .PEN: "Peñota",
            .BOL: "Bolueta",
            .BAS: "Basarrate",
            .SAN: "Santutxu",
            .SAR: "Sarriko",
            .SOP: "Sopela",
            .POR: "Portugalete",
            .LAM: "Lamiako",
            .ARE: "Areeta",
            .NEG: "Neguri",
            .SES: "Sestao",
            .AST: "Astrabudua",
            .LEI: "Leioa",
            .ALG: "Algorta",
            .URD: "Urduliz",
            .BAG: "Bagatza",
            .CAV: "Zazpikaleak/Casco Viejo",
            .SIN: "San Ignazio",
            .AIB: "Aiboa",
            .GUR: "Gurutzeta/Cruces",
            .STZ: "Santurtzi",
            .ABT: "Abatxolo",
            .IND: "Indautxu",
            .GOB: "Gobela",
            .BID: "Bidezabal",
            .IBB: "Ibarbengoa",
            .LAR: "Larrabasterra",
            .PLE: "Plentzia",
            .ARZ: "Ariz",
            .DEU: "Deustu",
            .BER: "Berango",
            .ABA: "Abando",
            .MOY: "Moyua",
            .LUT: "Lutxana",
            .ERA: "Erandio",
            .BAR: "Barakaldo"
        ]
    }
}
*/

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
    ]
}
