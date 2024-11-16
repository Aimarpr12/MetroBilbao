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
}
