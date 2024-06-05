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

### Cosas hechas hasta el momento

- El usuario elige los nombres de los jugadores y los emojis del zorro y ocas
- !! Se debería poner un menú de opciones; si no quiere personalizar el juego se debería usar un tablero default (el que está en main)
- De la personalización faltaría hacer la opción para que elija la orientación del tablero
- Empezamos con la validación de los movimientos para el zorro y ocas, pero falta terminarlo (hasta ahora sólo chequeamos que la fila y columna que ingresa está entre 1 y 7)