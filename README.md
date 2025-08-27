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

