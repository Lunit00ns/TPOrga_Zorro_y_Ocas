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

**Requerimento 1**
- [ ] Permitir interrumpir la partida en cualquier momento del juego. (Salir del juego)
- [ ] Identificar automáticamente cuando el juego llegó a su fin indicado el motivo. (por haber comido el zorro 12 ocas o por quedar el zorro “acorralado” sin poder moverse)

**Requerimento 2**
- [ ] Permitir guardar la partida y poder recuperarla en otro momento en el mismo estado.
- [ ] Mostrar estadísticas de movimiento del zorro al finalizar el juego. (cantidad de movimientos en cada uno de los sentidos posibles)

**Requerimento 3**
- [x] Opción de personalización de partida.

## Errores:
- No funciona bien el rango válido de las opciones de emojis (ej.: si pone 33333 toma como que es una respuesta válida y agarra la opción 3)

- Tira un Segmentation fault (core dumped) imprimir_tablero

- Se supone que en r10 queda guardado un vector con la posición del zorro, pero no puedo hacer que lo imprima para chequear que esté bien.

### Cosas hechas hasta el momento
- Empezamos con la validación de los movimientos para el zorro y ocas, pero falta terminarlo (falta verificar que funcione bien comer a las ocas y que el turno de las ocas este bien)
- despues del turno del zorro se actualiza el tablero, habria que ver que todo funcione.