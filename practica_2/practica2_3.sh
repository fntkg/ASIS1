#!/bin/bash
#735576, Briones Yus, Patricia, T, 1, A
#757024, Garcés Latre, Germán, T, 1, A

# Si se introduce ninguno o mas de un fichero el script termina
test $# -ne 1 && echo "Sintaxis: practica2_3.sh <nombre_archivo>" && exit 1	

# Si el fichero no existe, el script termina, si no se hace ejecutable para el dueño y el grupo y muestra los permisos finales
test -f "$1" && chmod ug+x "$1" && stat -c%A "$1" || echo "$1 no existe" && exit 1					
