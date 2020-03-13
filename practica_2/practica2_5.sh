#!/bin/bash
#735576, Briones Yus, Patricia, T, 1, A
#757024, Garcés Latre, Germán, T, 1, A

echo -n "Introduzca el nombre de un directorio: "
read directorio

test ! -d "$directorio" && echo "$directorio no es un directorio" && exit 1	# Si no es un directorio el script termina

nDir=$(find "$directorio" -mindepth 1 -maxdepth 1 -type d | wc -l)	# Busca en el directorio todos los archivos de tipo directorio (SOLO EN SU NIVEL) y los cuenta
nFich=$(find "$directorio" -type f | wc -l)				# Busca en el directorio todos los archivos de tipo fichero en todos los niveles y los cuenta

echo "El numero de ficheros y directorios en $directorio es de $nFich y $nDir, respectivamente"
