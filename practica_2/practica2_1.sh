#!/bin/bash
#735576, Briones Yus, Patricia, T, 1, A
#757024, Garcés Latre, Germán, T, 1, A

echo -n "Introduzca el nombre del fichero: "			# -n evita que haya un salto de linea despues del echo
read nombre							# Guarda el nombre del fichero introducido en la variable nombre

test ! -f "$nombre" && echo "$nombre no existe" && exit 1	# Si el fichero no existe el script termina

permisos=$(stat -c%A "$nombre")					# Guarda todos los permisos del fichero
echo "Los permisos del archivo $nombre son: ${permisos:1:3}"	# Empieza en la posición 1 de permisos y cuenta 3 caracteres
