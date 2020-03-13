#!/bin/bash
#735576, Briones Yus, Patricia, T, 1, A
#757024, Garcés Latre, Germán, T, 1, A

for fichero in "$@"			# se pone entre comillas para que distingan los espacios y reconozca cada fichero
do
	test -f "$fichero" && more "$fichero" || echo "$fichero no es un fichero"	# Comprueba si fichero es un fichero
done
