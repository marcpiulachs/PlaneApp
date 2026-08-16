# Spec de Tokens de Estilo — Paperwings (PlaneApp)

## Objetivo
Reducir los estilos inline, añadir los tokens necesarios y consolidar la paleta.
Hoy hay ~553 ocurrencias de estilos/valores literales (`TextStyle`, `Colors.*`,
`EdgeInsets`, `BorderRadius`, `BoxDecoration`). Muchas repiten el mismo patrón
con variaciones que no coinciden exactamente.

## Principios
1. **Un solo origen de verdad**: `AppTheme` es la fuente única. Los widgets usan
   `AppTheme.*` (o `Theme.of(context)` para colores del tema). Nada de literales.
2. **Tokens semánticos, no descriptivos**: `cardColor`, `textPrimary`,
   `textSecondary`, `statusError` — no `grey850`.
3. **Consistencia de superficies**: decidir UNA convención de fondo/tarjeta y
   eliminar las mezclas (hoy conviven `backgroundDark`, `surfaceDark`, `grey[900]`,
   `grey[850]`, `Colors.black`).
4. **Mínimo incremento**: solo los tokens que los archivos reales necesitan.

---

## 1. Colores (AppTheme)

### Superficies (consolidar)
| Token | Valor | Sustituye a |
|---|---|---|
| `backgroundDark` | `0xFF121212` | fondo de página (mantener) |
| `surfaceDark` | `0xFF1E1E1E` | tarjetas, appbar (mantener) |
| `surfaceDarker` | `0xFF2C2C2C` | inputs, badges (mantener) |
| `cardColor` | `surfaceDark` (nuevo alias) | `Colors.grey[850]`, `Colors.grey[900]` |
| `scrim`/`buttonColor` | `surfaceDarker` | `Colors.black` en botones |

### Texto
| Token | Valor | Sustituye a |
|---|---|---|
| `textPrimary` | `Colors.white` | `Colors.white` |
| `textSecondary` | `Colors.white70` | `Colors.white70`, `white.withOpacity(0.7)` |
| `textTertiary` | `Colors.white54` | `Colors.white54`, `white54` |
| `textMuted` | `Colors.white38`/`0.3` | `white.withOpacity(0.3)` |

### Estado (ya existen: success/warning/error/info)
Confirmar que `error`==`Colors.red`, `success`==`Colors.green` se usan siempre
vía token (hoy `flight_detail_page` usa `Colors.red`/`Colors.green` literales).

### Datos/charts (nuevo grupo)
| Token | Valor | Uso |
|---|---|---|
| `chartPitch` | `Colors.red` | serie pitch |
| `chartRoll` | `Colors.deepPurple`/`Colors.lightBlue` | serie roll |
| `chartYaw` | `Colors.lightBlue` | serie yaw |
| `chartAccelX/Y/Z` | `Colors.red/green/blue` | aceleración |
| `chartGyroX/Y/Z` | `Colors.pinkAccent/tealAccent/amberAccent` | giroscopio |
| `chartMotor1/2` | `Colors.orange/deepOrange` | motores |
| `chartReq` | `Colors.green` | requerido (motor_settings) |
| `chartCur` | `Colors.yellow` | actual (motor_settings) |

---

## 2. Tipografía

Consolidar `TextTheme` existente y añadir lo que falta. Todos deben resolver a
tokens en `AppTheme`:

| Token | fontSize | weight | color | Sustituye a |
|---|---|---|---|---|
| `heading1` | 24 | bold | white | (existe) |
| `heading2` | 20 | bold | white | (existe) |
| `heading3` | 18 | bold | white | título secciones (existe) |
| `bodyLarge` | 16 | normal | white | (existe) |
| `bodyMedium` | 14 | normal | white70 | (existe) |
| `bodySmall` | 12 | normal | white60 | (existe) |
| `labelLarge` | 16 | bold | white | botones (existe) |
| **`labelMedium`** | **14** | **bold** | **white** | títulos de slider |
| **`statValue`** | **18** | **bold** | **white** | valores de stats |
| **`statLabel`** | **12** | **normal** | **white70** | labels de stats |
| **`metricLabel`** | **13** | **normal** | **white70** | labels de métricas |
| **`chartAxis`** | **10** | **normal** | **white70** | ejes de charts |
| **`statusMessage`** | **16** | **normal** | **white** | mensajes calibración |
| **`statusSuccess`** | **16** | **bold** | **green** | éxito |
| **`statusError`** | **16** | **bold** | **red** | error |
| **`countdown`** | **48** | **bold** | **white** | contador calibración |

---

## 3. Espaciado (nuevo grupo `AppSpacing`)
| Token | Valor | Sustituye a |
|---|---|---|
| `spacingXs` | 4 | `SizedBox(height: 4)` |
| `spacingSm` | 8 | `SizedBox(height/width: 8)` |
| `spacingMd` | 12 | `SizedBox(...: 12)` |
| `spacingLg` | 16 | `SizedBox(...: 16)`, `EdgeInsets.all(16)` |
| `spacingXl` | 20 | `EdgeInsets.all(20)` |
| `pagePadding` | `EdgeInsets.all(16)` | páginas |
| `cardPadding` | `EdgeInsets.all(16)` | tarjetas |
| `listPadding` | `EdgeInsets.all(8)` | listas |

---

## 4. Radios (nuevo grupo `AppRadius`)
| Token | Valor | Sustituye a |
|---|---|---|
| `radiusSm` | 8 | botones, inputs, tooltips |
| `radiusMd` | 12 | tarjetas, badges |
| `radiusLg` | 16 | tarjetas grandes |
| `radiusPill` | 20 | badges pill |
| `radiusCircle` | `BoxShape.circle` | avatares/indicadores |

---

## 5. Mapa de reemplazos (resumen)
| Patrón actual (ejemplos) | Token destino |
|---|---|
| `Colors.grey[850]`, `Colors.grey[900]` | `AppTheme.cardColor` / `backgroundDark` |
| `Colors.black` (botones) | `AppTheme.buttonColor` |
| `Colors.black` (círculos icono) | `AppTheme.surfaceDarker` |
| `TextStyle(fontSize:18,bold,white)` (títulos) | `AppTheme.heading3` |
| `TextStyle(fontSize:16,bold,white)` (sub-títulos) | `AppTheme.heading3` o `labelLarge` |
| `TextStyle(fontSize:18,bold,white)` (stat value) | `AppTheme.statValue` |
| `TextStyle(fontSize:12/13,white70)` (labels) | `AppTheme.statLabel` / `metricLabel` |
| `TextStyle(fontSize:10,white70)` (ejes) | `AppTheme.chartAxis` |
| `TextStyle(fontSize:16,white)` (mensajes) | `AppTheme.statusMessage` |
| `TextStyle(fontSize:16,bold,green/red)` | `AppTheme.statusSuccess/statusError` |
| `SizedBox(height:8/16)` | `AppSpacing.spacingSm/Lg` |
| `BorderRadius.circular(8/12/16/20)` | `AppRadius.radiusSm/Md/Lg/Pill` |

---

## 6. Archivos prioritarios (orden de aplicación)
1. `pages/flight_detail_page.dart` — 44 estilos, 3 convenciones de superficie
   mezcladas (`grey[900]`, `grey[850]`, literales). El peor caso.
2. `pages/recorder.dart` — 30 estilos; consolidar badge de estado.
3. `pages/settings.dart`, `pages/calibration_imu_page.dart`,
   `pages/calibration_mag_page.dart` — mismos patrones de mensaje/botón.
4. `pages/mechanics.dart`, `pages/flight_settings.dart`, `pages/motor_settings.dart`
   — botones negros y títulos repetidos.
5. `pages/fly.dart` — estilos de cockpit (ya usa tokens, revisar restos).

## 7. Widgets a extraer (Fase 2)
- `StatusBadge` (crash/emergencia/advertencia) de `recorder.dart`.
- `StatusCard` de `flight_detail_page.dart`.
- `IconCircle` (círculo 40x40 con icono) — repetido en calibraciones,
  `mechanics.dart`, `beacon_settings.dart`, `flight_settings.dart`.
- `FullWidthButton` (botón negro 50px de alto) — repetido en 6+ sitios.

## 8. Criterios de aceptación
- `flutter analyze` sin errores nuevos.
- Cero literales `Colors.grey[...]`, `Color(0x...)` duplicados fuera de `AppTheme`.
- Ningún `TextStyle(...)` duplicado de los patrones de la tabla; todos resuelven
  a token.
- Sin cambio visual intencional (solo consolidación).