![light](Docs/MetroBanner.jpeg)

# 🚇 Metro Bilbao Widget

Widget para iOS que muestra los próximos trenes entre dos estaciones del Metro de Bilbao. Desarrollado en SwiftUI con integración de WidgetKit y App Intents.

---

## 📲 Funcionalidades

- Selección de estación de origen y destino  
- Modo de salida inmediata o programada  
- Consulta de horarios en tiempo real  
- Compatibilidad con modo oscuro  
- Widget personalizable desde la pantalla de inicio

---

## 🛠️ Tecnologías

- SwiftUI  
- WidgetKit  
- App Intents  
- URLSession + JSON  
- Xcode 16  
- iOS 17+

---

## 📷 Capturas de pantalla

| Modo Claro | Modo Oscuro |
|------------|-------------|
| ![light](Docs/light.jpeg) | ![dark](Docs/dark.jpeg) |

---

## ⚙️ Instalación

1. Clona el repositorio:
   ```bash
   git clone https://github.com/Aimarpr12/MetroBilbao
   ```
2. Abre el proyecto en Xcode.
3. Configura el equipo en `Signing & Capabilities`.
4. Selecciona un dispositivo físico y ejecuta con ⌘R.

> ⚠️ **Nota:** La extensión del widget requiere ejecución en dispositivo real.

---

## 🧪 Estado del desarrollo

- [x] Selección de estaciones  
- [x] Visualización de horarios  
- [x] Soporte para WidgetKit  
- [ ] Notificaciones personalizadas  
- [ ] Traducción a euskera  

---

## 📄 Licencia

MIT License  
© [Aimar Pelea](https://github.com/Aimarpr12)

---

### 🗂️ Fuente de datos

Los horarios y tiempos reales se obtienen del dataset **“Metro Bilbao – Datos de tiempos reales (GTFS-RT)”** publicado por **Metro Bilbao / Consorcio de Transportes de Bizkaia (CTB)**.  
Se reutilizan bajo la licencia [Creative Commons Atribución 4.0 Internacional](https://creativecommons.org/licenses/by/4.0/).  
Catálogo oficial de datos abiertos: <https://data.ctb.eus/es/dataset/>
