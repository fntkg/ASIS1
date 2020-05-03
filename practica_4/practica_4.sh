#!/bin/bash
#735576, Briones Yus, Patricia, T, 1, A
#757024, Garcés Latre, Germán, T, 1, A

anyadirU() {
	# Guardamos el caracter delimitador y fija el nuevo ", "
	old_IFS="$IFS"
	IFS=","

	# En caso de tener mas de tres atributos por linea ignora los siguientes
	while read user pass nombre invalid	
	do
		# Si alguno de los 3 campos es igual a la cadena vacia se abortará la ejecución
		test -z "$user" && test -z "$pass" && test -z "$nombre" && echo "Campo invalido" && exit 1
		
		# Si el usuario existe, ni se añadirá ni se cambiará su contraseña
		ssh -i ~/.ssh/id_as_ed25519 -n as@"$2" "sudo getent passwd "$user">/dev/null"
		if [ $? -eq 0 ]; then
			echo "El usuario $user ya existe"
		else		
			# Los usuarios deberán tener un UID mayor o igual que 1815, el directorio home de cada usuario se inicializará con los ficheros de /etc/skel, tendrá como grupo por defecto uno con su mismo nombre
			ssh -i ~/.ssh/id_as_ed25519 -n as@"$2" "useradd -d "/home/$user" -U -K UID_MIN=1815 -c "$nombre" -m -k /etc/skel "$user""

			# Establece su contraseña
			ssh -i ~/.ssh/id_as_ed25519 -n as@"$2" "echo "$user:$pass" | chpasswd"

			# La caducidad de la nueva contraseña establecida será de 30 días
			cssh -i ~/.ssh/id_as_ed25519 -n as@"$2" "hage -M 30 "$user""
			echo "$nombre ha sido creado"
		fi

	done<"$1"

	# Devolvemos el valor inicial al delimitador
	IFS="$old_IFS"
}

eliminarU() {
	# Se debe crear el directorio /extra/backupp aunque no se borre ningun usuario
	ssh -i ~/.ssh/id_as_ed25519 -n as@"$2" "mkdir -p "/extra/backup"&>/dev/null"

	for usuario in $(cut -d ',' -f1 "$1")
	do
		# comprueba si existe el usuario
		ssh -i ~/.ssh/id_as_ed25519 -n as@"$2" "getent passwd "$usuario">/dev/null"
		if [ $? -eq 0 ]; then
			# guardamos en user_home el directorio
			user_home=$(ssh -i ~/.ssh/id_as_ed25519 -n as@"$2" "getent passwd "$usuario"" | cut -d':' -f6)		

			# bloquea la cuenta del usuario para que no pueda acceder
			ssh -i ~/.ssh/id_as_ed25519 -n as@"$2" "usermod -L "$usuario""
	
			# Antes de borrar un usuario, realizará un backup de su directorio home y se guardara en /extra/backup
			# En caso de que el backup no pueda ser completado satisfactoriamente, no se realizará el borrado
			ssh -i ~/.ssh/id_as_ed25519 -n as@"$2" "tar -cf "/extra/backup/$usuario.tar" "$user_home" &>/dev/null && userdel -rf "$usuario"&>/dev/null"
		fi
	done<"$1"
}

# Comprobación de usuario con privilegios de administración
test $EUID != 0 && echo "Este script necesita privilegios de administracion" && exit 1

# Cuando el número de argumentos sea distinto de 3 el script termina
test $# -ne 3 && echo "Numero incorrecto de parametros" && exit 1

while read ip
do
	# Si el puerto de la dirección ip está cerrado no puede conectarse a una máquina
	! nc -z $ip 22 2>/dev/null && echo "$ip no es accesible" && exit 1

	# Cualquier otra opción generará el mensaje de error por la salida de error, stderr.
	if [ "$1" = "-a" ]; then
		anyadirU "$2"
	elif [ "$1" = "-s" ]; then
		eliminarU "$2"
	else
		echo "Opcion invalida" 2>&1
	fi
done<"$3"
