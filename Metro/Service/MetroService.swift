import Foundation
import SwiftUI

class MetroService {
    static let shared = MetroService()
    
    private init() {} // Para asegurar una instancia única si se usa como singleton
    
    func buscarRuta(
        salida: String,
        llegada: String,
        tipoSalida: TipoSalida,
        fechaSeleccionada: Date? = nil,
        horaDesde: Date? = nil,
        horaHasta: Date? = nil,
        completion: @escaping ([Ruta]) -> Void
    ) {
        var urlString = "https://api.metrobilbao.eus/metro/real-time/\(salida)/\(llegada)"
        if tipoSalida == .programada,
           let fecha = fechaSeleccionada,
           let desde = horaDesde,
           let hasta = horaHasta {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let formattedDate = dateFormatter.string(from: fecha)
            
            let calendar = Calendar.current
            let hourDesde = calendar.component(.hour, from: desde)
            let minuteDesde = calendar.component(.minute, from: desde)
            let formattedTimeDesde = "\(hourDesde).\(minuteDesde)"
            
            let hourHasta = calendar.component(.hour, from: hasta)
            let minuteHasta = calendar.component(.minute, from: hasta)
            let formattedTimeHasta = "\(hourHasta).\(minuteHasta)"
            
            urlString = "https://api.metrobilbao.eus/metro/obtain-schedule-of-trip/\(salida)/\(llegada)/\(formattedTimeDesde)/\(formattedTimeHasta)/\(formattedDate)/es"
            
        }
        print(urlString)
        guard let url = URL(string: urlString) else {
            print("URL no válida")
            completion([])
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error en la solicitud: \(error)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No se recibió data")
                completion([])
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    var nuevasRutas: [Ruta] = []
                    
                    if tipoSalida == .inmediata {
                        if let trip = json["trip"] as? [String: Any],
                           let trains = json["trains"] as? [[String: Any]],
                           let transbordo = trip["transfer"] as? Bool,
                           let transbordoTexto = transbordo ? "Si" : "No",
                           let duration = trip["duration"] as? Int {
                            for train in trains {
                                if let timeRounded = train["timeRounded"] as? String,
                                   let estimated = train["estimated"] as? Int {
                                    let salidaHora = timeRounded
                                    let llegadaHora = self.calcularHoraLlegada(hora: timeRounded, minutos: duration)
                                    
                                    let nuevaRuta = Ruta(horaSalida: salidaHora, horaLlegada: llegadaHora, duracion: duration, trasbordo: transbordoTexto)
                                    nuevasRutas.append(nuevaRuta)
                                }
                            }
                        }
                    } else {
                        if let trips = json["trips"] as? [String: Any] {
                            let transbordo = json["transfer"] as? Bool ?? false
                            let transbordoTexto = transbordo ? "Si" : "No"
                            let timeString = json["time"] as? String ?? "0"
                            let time = Int(timeString) ?? 0
                            
                            for (_, tripArray) in trips {
                                if let tripData = tripArray as? [[String: Any]] {
                                    for trip in tripData {
                                        guard let originArrivalTimeRounder = trip["originArrivalTimeRounder"] as? String,
                                              let destinyArrivalTimeRounder = trip["destinyArrivalTimeRounder"] as? String else {
                                            continue
                                        }
                                        
                                        let duracion = time == 0 ? trip["time"] as? Int ?? 0 : time
                                        let nuevaRuta = Ruta(
                                            horaSalida: originArrivalTimeRounder,
                                            horaLlegada: destinyArrivalTimeRounder,
                                            duracion: duracion,
                                            trasbordo: transbordoTexto,
                                            originTime: trip["originTime"] as? [String: Any]
                                        )
                                        nuevasRutas.append(nuevaRuta)
                                    }
                                }
                            }
                            
                            nuevasRutas.sort { ruta1, ruta2 in
                                guard let originTime1 = ruta1.originTime,
                                      let originTime2 = ruta2.originTime,
                                      let date1String = originTime1["date"] as? String,
                                      let date2String = originTime2["date"] as? String else {
                                    return false
                                }
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
                                dateFormatter.timeZone = TimeZone(identifier: "Europe/Madrid")
                                
                                if let date1 = dateFormatter.date(from: date1String),
                                   let date2 = dateFormatter.date(from: date2String) {
                                    return date1 < date2
                                }
                                
                                return false
                            }
                        }
                    }
                    
                    completion(nuevasRutas)
                } else {
                    print("El JSON no contiene la estructura esperada")
                    completion([])
                }
            } catch {
                print("Error al analizar JSON: \(error)")
                completion([])
            }
        }.resume()
    }
    
    private func calcularHoraLlegada(hora: String, minutos: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let date = dateFormatter.date(from: hora) else { return "N/A" }
        let llegada = Calendar.current.date(byAdding: .minute, value: minutos, to: date)
        
        return dateFormatter.string(from: llegada ?? date)
    }
}
