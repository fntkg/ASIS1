#!/bin/bash
#735576, Briones Yus, Patricia, T, 1, A
#757024, Garcés Latre, Germán, T, 1, A

IFS=","

# Comprobar sintaxis script
test $# -ne 2 && echo "Numero incorrecto de parametros" && exit 1

# Comprobar privilegios usuario
test "$EUID" -ne 0 && echo "Este script necesita privilegios de administracion" && exit 1

# Comprobar parametros script
[[ "$1" != "-a" && "$1" != "-s" ]] && >&2 echo "Opcion invalida"

# Caso borrar usuarios
[ "$1" = "-s" ] && while IFS=, read -r user
do
	mkdir "/extra/backup" &>/dev/null
	tar -cvf "$user".tar "~$user/*" -C "/extra/backup" && userdel -r "$user" &>/dev/null
done < "$2"

# Caso añadir usuarios
[ "$1" = "-a" ] && while IFS=, read -r user pass name
do
	[ "$user" = "" || "$pass" = "" || "$name" = "" ] && echo "Campo invalido" && exit 1
	useradd -f 30 -u $(shuf -i 1815-3000) -G "$user" -c "$name"
	[ $? -eq 9 ] && echo "El usuario $user ya existe" || groupadd "$user" && usermod -g "$user" "$user" && echo "$user:$pass" | chpasswd && echo "$name ha sido creado"
done < "$2"
