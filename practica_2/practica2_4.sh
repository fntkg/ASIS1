#!/bin/bash
#735576, Briones Yus, Patricia, T, 1, A
#757024, Garcés Latre, Germán, T, 1, A

echo -n "Introduzca una tecla: "
read tecla					# Guarda en tecla lo introducido

case "${tecla:0:1}" in				# Selecciona de tecla desde la posición 0 a la 1, es decir, el primer caracter
[a-z,A-Z])					# Si es un caracter comprendido entre [a-z,A-Z]
	echo "${tecla:0:1} es una letra" ;;
[0-9])						# Si es un caracter comprendido entre [0-9]
	echo "${tecla:0:1} es un numero" ;;	
*)						# Si no es ninguno de los casos anteriores
	echo "${tecla:0:1} es un caracter especial" ;;
esac
