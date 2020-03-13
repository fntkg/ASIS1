#!/bin/bash
#735576, Briones Yus, Patricia, T, 1, A
#757024, Garcés Latre, Germán, T, 1, A

# Buscamos si hay uno o varios directorios que siguen el patron, y elegimos el menos recientemente modificado y redirige las salidas de error a /dev/null
directorio=$(find $HOME/bin??? -maxdepth 0 -type d 2>/dev/null | xargs stat -c %n,%Y 2>/dev/null | sort -k2n | head -1 | cut -d',' -f1)

# Si su longitud de caracteres es 0 (no existe ningun directorio que siga el patron) y crea un directorio temporal
test -z "$directorio" && directorio=$(mktemp -d $HOME/binXXX) && echo "Se ha creado el directorio $directorio"

echo "Directorio destino de copia: $directorio"

contador=0
while read archivo
do
	cp "$archivo" "$directorio" && echo "$archivo ha sido copiado a $directorio" && contador=$(($contador+1))
done< <(find . -mindepth 1 -maxdepth 1 -type f -executable)				# Lee todos los ficheros del directorio actual que sean ejecutables

test $contador -eq 0 && echo "No se ha copiado ningun archivo" || echo "Se han copiado $contador archivos"




