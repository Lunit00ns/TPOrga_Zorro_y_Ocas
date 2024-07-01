# Orga - TP: El Zorro y las Ocas

Trabajo Práctico "El Zorro y las Ocas". Organización del Computador - Curso Benítez.

## Integrantes
- Santiago Ligregni - 110581
- Luna Dufour - 110438
- Tomás Koch - 110687
- Lucía Almanza - 110598

## Descripción del programa

Implementación del juego _El Zorro y las Ocas_ en assembler Intel 80x86. El programa cuenta con:

- **Personalización de partida**: El usuario tiene la opción de elegir los símbolos para el Zorro y las Ocas, así como la orientación del tablero. En caso que no se desee personalizar, el juego cuenta con una configuración por default.
- **Guardar y cargar partida**: No está todavía, eventualmente estará... qué tan difícil puede ser ¿

<div style="text-align: center;">
  <img src="https://i.pinimg.com/originals/7f/24/4e/7f244e0236bde8ea6056384286304a26.gif" alt="Gif Zorro">
</div>

## Requerimentos hasta ahora:

**Requerimiento 1**
- [x] Permitir interrumpir la partida en cualquier momento del juego. (Salir del juego)
- [x] Identificar automáticamente cuando el juego llegó a su fin indicado el motivo. (por haber comido el zorro 12 ocas o por quedar el zorro “acorralado” sin poder moverse)

**Requerimiento 2**
- [\] Permitir guardar la partida y poder recuperarla en otro momento en el mismo estado.
- [x] Mostrar estadísticas de movimiento del zorro al finalizar el juego. (cantidad de movimientos en cada uno de los sentidos posibles)

**Requerimiento 3**
- [x] Opción de personalización de partida.

## Errores:
- Se guarda la partida bien cada vez que el usuario sale del juego. Cuando quiere cargar la última partida guardada, falla (posiblemente por las variables globales)