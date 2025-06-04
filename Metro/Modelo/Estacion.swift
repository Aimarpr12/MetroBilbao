//
//  Estacion.swift
//  Metro
//
//  Created by Aimar Pelea on 11/3/24.
//



enum Estacion: String, CaseIterable, Identifiable {
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
    
    var id: String { self.rawValue }
    
    init?(apiCode: String) {
        switch apiCode {
        case "BSR": self = .BSR
        case "ETX": self = .ETX
        case "SAM": self = .SAM
        case "ANS": self = .ANS
        case "URB": self = .URB
        case "KAB": self = .KAB
        case "PEN": self = .PEN
        case "BOL": self = .BOL
        case "BAS": self = .BAS
        case "SAN": self = .SAN
        case "SAR": self = .SAR
        case "SOP": self = .SOP
        case "POR": self = .POR
        case "LAM": self = .LAM
        case "ARE": self = .ARE
        case "NEG": self = .NEG
        case "SES": self = .SES
        case "AST": self = .AST
        case "LEI": self = .LEI
        case "ALG": self = .ALG
        case "URD": self = .URD
        case "BAG": self = .BAG
        case "CAV": self = .CAV
        case "SIN": self = .SIN
        case "AIB": self = .AIB
        case "GUR": self = .GUR
        case "STZ": self = .STZ
        case "ABT": self = .ABT
        case "IND": self = .IND
        case "GOB": self = .GOB
        case "BID": self = .BID
        case "IBB": self = .IBB
        case "LAR": self = .LAR
        case "PLE": self = .PLE
        case "ARZ": self = .ARZ
        case "DEU": self = .DEU
        case "BER": self = .BER
        case "ABA": self = .ABA
        case "MOY": self = .MOY
        case "LUT": self = .LUT
        case "ERA": self = .ERA
        case "BAR": self = .BAR
        default:
            return nil
        }
    }
}
