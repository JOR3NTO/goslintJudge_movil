# goslintJudge_movil
# Proyecto Goslint Judge Movil

Este repositorio contiene el código del proyecto Goslint Judge Movil.  
Para garantizar la calidad del código y mantener una buena colaboración en equipo, hemos definido reglas de trabajo y configurado protecciones sobre la rama principal.

---

## Reglas de colaboración

1. **Rama principal protegida (`main`)**
   - No se permite hacer `push` directo a la rama `main`.
   - Está bloqueada la eliminación de la rama.
   - Están bloqueados los `force push`.

2. **Uso de Pull Requests (PR)**
   - Todos los cambios deben realizarse en ramas de características (ej: `feature/nueva-funcionalidad`) o ramas de corrección (ej: `fix/error-x`).
   - Para fusionar una rama con `main` es obligatorio abrir un **Pull Request**.
   - Cada Pull Request debe ser aprobado por al menos **1 revisor** antes de poder hacer merge.

3. **Commits**
   - Se recomienda usar mensajes de commit claros y descriptivos.
   - Ejemplo:  
     - `feat: agregar formulario de registro`  
     - `fix: corregir validación de email en login`

4. **Historial**
   - Se prefiere mantener un historial de commits claro y lineal (sin `merge` innecesarios).
   - Se recomienda el uso de `rebase` antes de abrir un PR.

---

## Configuración de GitHub

En la sección de **Branch protection rules** se activaron las siguientes opciones para la rama `main`:

- **Restrict deletions**  
- **Block force pushes**  
- **Require a pull request before merging** (con mínimo 1 aprobación de revisión)  

---

## Flujo de trabajo recomendado

1. Crear una rama desde `main`:
   ```bash
   git checkout -b feature/nueva-funcionalidad
   ```

---

## Descripción funcional de la app

Goslint Judge Móvil es una aplicación Flutter multiplataforma (Android, iOS, Web, Desktop) que permite a los usuarios:

- Registrarse y autenticarse con backend propio (Spring Boot)
- Visualizar un panel de bienvenida personalizado
- Navegar por un dashboard con tarjetas de resumen (envíos, aprobados, rechazados, puntaje, feedback AI)
- Consultar una lista de envíos de ejercicios (mock data por ahora)
- Acceder a menú lateral (Drawer) para navegar entre secciones

### Flujo principal

1. **Login:**
   - El usuario ingresa su correo y contraseña.
   - Si es exitoso, se muestra un mensaje de bienvenida con su nombre real (devuelto por el backend).
   - Si falla, se muestra el error correspondiente.

2. **Registro:**
   - Formulario con nombre, correo y contraseña.
   - Valida campos y envía datos al endpoint `/api/auth/register`.
   - Muestra mensaje de éxito o error según respuesta del backend.

3. **Panel de bienvenida:**
   - Mensaje: "¡Bienvenido NOMBRE!"
   - Redirección automática al dashboard principal.

4. **Dashboard/Home:**
   - Tarjetas con resumen de actividad.
   - Acceso a lista de envíos y otras secciones.

5. **Lista de envíos:**
   - Muestra ejemplos de envíos con estado, fecha, puntaje, etc.
   - Por ahora, usa datos de ejemplo (mock).

### Integración backend

- **Registro:** POST a `/api/auth/register` con `{ nombre, emailContacto, password }`
- **Login:** POST a `/api/auth/login` con `{ email, password }`, espera `{ nombre, ... }` en respuesta.
- El nombre real se usa para personalizar la bienvenida.

### Estructura de carpetas

- `lib/main.dart` — entrypoint
- `lib/src/app.dart` — configuración de rutas
- `lib/src/features/login/` — login_page.dart, register_page.dart
- `lib/src/features/home/` — home_page.dart, sent_page.dart, welcome_page.dart
- `lib/src/shared/services/` — auth_service.dart (servicios de autenticación)
- `test/` — pruebas widget

### Estado actual

- UI moderna, dark theme, logo personalizado
- Navegación funcional entre todas las pantallas
- Registro y login conectados al backend
- Mensajes de error y éxito claros
- Listas y tarjetas con datos de ejemplo

---

## Próximos pasos sugeridos

- Integrar la lista de envíos con datos reales del backend
- Implementar almacenamiento seguro de sesión/token
- Mejorar feedback visual y validaciones
- Agregar más secciones y funcionalidades según necesidades

