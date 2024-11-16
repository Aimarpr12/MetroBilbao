//
//  Ruta.swift
//  Metro
//
//  Created by Aimar Pelea on 11/3/24.
//

import Foundation

struct Ruta: Identifiable {
    let id = UUID()
    let horaSalida: String
    let horaLlegada: String
    let duracion: Int
    let trasbordo: String
    var originTime: [String: Any]? 
}
