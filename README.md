# PokéGlobal

![Portada PokéGlobal](https://res.cloudinary.com/panmecar/image/upload/v1772819428/pokeglobal/Gemini_Generated_Image_cr9t91cr9t91cr9t_p8hpov.png)

**PokéGlobal** es una aplicación móvil desarrollada en Flutter para explorar la Pokédex, ver detalles de Pokémon, filtrar por tipo y gestionar favoritos. Consume [PokeAPI](https://pokeapi.co/) y persiste favoritos en local.


---

## Contenido

- [Capturas de pantalla](#-capturas-de-pantalla)
- [Cómo ejecutar el proyecto](#-cómo-ejecutar-el-proyecto)
- [Tecnologías y decisiones](#-tecnologías-y-decisiones)
- [Arquitectura](#-arquitectura)
- [Uso de IA en el proyecto](#-uso-de-ia-en-el-proyecto)
- [Seguridad](#-seguridad)

---

## 🖼️ Capturas de pantalla

| Screenshot 1 | Screenshot 2 | Screenshot 3 |
|--------------|--------------|--------------|
| ![Screenshot 1](https://res.cloudinary.com/panmecar/image/upload/v1772819038/pokeglobal/Simulator_Screenshot_-_iPhone_17_Pro_-_2026-03-06_at_12.35.52_jbdjtn.png) | ![Screenshot 2](https://res.cloudinary.com/panmecar/image/upload/v1772819038/pokeglobal/Simulator_Screenshot_-_iPhone_17_Pro_-_2026-03-06_at_12.35.58_kqv2sd.png) | ![Screenshot 3](https://res.cloudinary.com/panmecar/image/upload/v1772819039/pokeglobal/Simulator_Screenshot_-_iPhone_17_Pro_-_2026-03-06_at_12.36.01_xnzije.png) |

| Screenshot 4 | Screenshot 5 |
|--------------|--------------|
| ![Screenshot 4](https://res.cloudinary.com/panmecar/image/upload/v1772819039/pokeglobal/Simulator_Screenshot_-_iPhone_17_Pro_-_2026-03-06_at_12.36.16_hdvbzc.png) | ![Screenshot 5](https://res.cloudinary.com/panmecar/image/upload/v1772819039/pokeglobal/Simulator_Screenshot_-_iPhone_17_Pro_-_2026-03-06_at_12.36.21_ofm0jh.png) |

---

## Cómo ejecutar el proyecto

### Requisitos

- [Flutter](https://flutter.dev/docs/get-started/install) (SDK ^3.10.7)
- Cuenta/entorno para ejecutar en iOS o Android

### Pasos

1. **Clonar el repositorio**

   ```bash
   git clone https://github.com/Alsahim0420/pokeglobal.git
   cd pokeglobal
   ```

2. **Configurar variables de entorno**

   Debes crear un archivo `.env` en la raíz del proyecto y **poner las URLs** de la API. Cópialo desde el ejemplo y luego edítalo:

   ```bash
   cp .env_example .env
   ```

   Abre `.env` y **añade estas URLs** (obligatorias para que la app funcione):

   ```env
   POKEAPI_BASE_URL=https://pokeapi.co/api/v2
   SPRITE_BASE_URL=https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork
   ```

   El `.env` se empaqueta como asset y se lee al arrancar la app.

3. **Instalar dependencias y ejecutar**

   ```bash
   flutter pub get
   flutter run
   ```

   Para generar código (Riverpod/Freezed) si hiciste cambios en anotaciones:

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

---

## Tecnologías y decisiones

| Área | Tecnología | Motivo |
|------|------------|--------|
| **UI** | Flutter + Material 3 | Una base de código para iOS y Android, diseño consistente. |
| **Estado** | Riverpod (flutter_riverpod + riverpod_annotation) | Inyección de dependencias y estado reactivo, tipado fuerte y generación de código. |
| **Red** | Dio | Cliente HTTP configurable, interceptors, timeouts; baseUrl y validación HTTPS centralizados. |
| **Persistencia local** | Hive (hive_flutter) | Almacenamiento local ligero para favoritos, sin SQL. |
| **Modelos** | Freezed | Inmutabilidad, unions y `copyWith` con menos boilerplate. |
| **Internacionalización** | flutter_localizations + gen-l10n | Textos en varios idiomas (ej. ES/EN) generados a partir de ARB. |
| **Configuración** | `.env` como asset | URLs y claves fuera del código; mismo flujo en desarrollo y al correr desde IDE/Xcode. |

Otras: **flutter_svg** para iconos/tipos, **flutter_slidable** para gestos en listas (ej. eliminar favorito).

---

## Arquitectura

Se sigue una **arquitectura en capas** inspirada en Clean Architecture, con dependencias hacia dentro (la UI no conoce la red ni el almacenamiento directo).

```
lib/
├── main.dart
├── core/                    # Infraestructura compartida
│   ├── env/                 # Carga de .env (AppEnv)
│   ├── security/            # Validación HTTPS (ensureHttps)
│   ├── theme/               # Tema claro/oscuro
│   ├── constants/           # Colores, assets, estilos de tipos
│   └── ...
├── data/                    # Capa de datos
│   ├── datasources/         # API (Dio) y local (Hive)
│   ├── models/               # DTOs y modelos de red/local
│   ├── mappers/              # DTO → entidad de dominio
│   └── repositories/         # Implementaciones de los contratos del dominio
├── domain/                  # Capa de dominio (sin Flutter)
│   ├── entities/            # Entidades de negocio
│   ├── repositories/        # Contratos (interfaces)
│   └── usecases/            # Casos de uso (orquestan repositorios)
└── presentation/            # Capa de presentación
    ├── screens/             # Pantallas
    ├── widgets/             # Componentes reutilizables
    └── providers/           # Providers Riverpod (usan use cases / repos)
```

- **Dominio:** define entidades, contratos de repositorios y casos de uso; no depende de Flutter ni de Dio/Hive.
- **Datos:** implementa los repositorios, usa datasources (Dio para PokeAPI, Hive para favoritos), mapea DTOs a entidades.
- **Presentación:** pantallas y widgets que leen estado desde Riverpod; los providers llaman a use cases o repositorios, no a datasources directamente.

Con esto se facilita testing (mockeando repositorios), cambios de API o de almacenamiento sin tocar la UI, y una responsabilidad clara por capa.

---

## Uso de IA en el proyecto

- **Herramienta:** se ha utilizado **Cursor** (y asistentes basados en IA) como apoyo durante el desarrollo.
- **Cómo se usa:**  
  - Generación y refactor de código (por ejemplo, providers Riverpod, mappers, manejo de `.env`).  
  - Revisión de seguridad (HTTPS, no exponer claves en logs, uso de `.env`).  
  - Documentación y redacción de este README (estructura, arquitectura, seguridad).  
  - Resolución de errores concretos y sugerencias de estilo (lints, buenas prácticas).
- **Rules / convenciones:**  
  No hay un archivo `.cursorrules` o `AGENTS.md` versionado en el repo. Las instrucciones al asistente se han dado por conversación (por ejemplo: “responder en español”, “no loguear request/response completos en producción”, “validar HTTPS”). Si en el futuro se definen reglas fijas, se pueden centralizar en `.cursor/rules` o en un `AGENTS.md` para que la IA siga convenciones de arquitectura, testing y seguridad de forma consistente.

---

## Seguridad

Se aplican las siguientes medidas en el código y en el flujo de desarrollo:

| Medida | Descripción |
|--------|-------------|
| **HTTPS obligatorio** | Todas las URLs de API se validan con `ensureHttps()` antes de usarlas. Si la URL está vacía o no es HTTPS, se lanza `InsecureUrlException` o `ArgumentError`. Así se evita enviar tráfico por HTTP por error. |
| **Configuración sensible en .env** | Las URLs base (`POKEAPI_BASE_URL`, `SPRITE_BASE_URL`) y una eventual clave (`POKEAPI_KEY`) se leen desde `.env`. No se hardcodean en el código. El archivo `.env` está en `.gitignore` para no subirlo al repositorio. |
| **Logs solo en debug** | Los interceptors de Dio que registran información de requests/responses (o errores) se añaden solo en `kDebugMode`. En release no se imprimen bodies ni headers para no exponer datos sensibles. |
| **Sin valores sensibles en logs** | Se evita loguear API keys o datos de usuario; en caso de errores se loguea solo lo necesario (por ejemplo, URI y mensaje de error) para depuración. |

En resumen: **configuración externa (.env), uso estricto de HTTPS y control de lo que se registra en logs** son las capas de seguridad aplicadas en este proyecto.

---

**Desarrollado con Flutter**
