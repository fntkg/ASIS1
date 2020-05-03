#!/bin/bash
#735576, Briones Yus, Patricia, T, 1, A
#757024, Garcés Latre, Germán, T, 1, A

# Comprueba que el numero de parametros introducidos sea 1
[[ $# -ne 1 ]] && echo "Numero incorrecto de parametros" && exit 1

# Guarda el caracter delimitador y fija el nuevo ", "
old_IFS="$IFS"; IFS=","

# En caso de tener mas atributos por linea de los indicados, los ignora
while read nom_vg nom_vl tam tipo_sf dir_montaje invalid
do
	# Comprueba si el grupo volumen introducido existe
	! sudo vgscan | grep -w "$nom_vg" >/dev/null && echo "El grupo volumen ${nom_vg} no existe" && exit 1

	# Comprueba si existe dicho volumen logico
	sudo lvscan | grep -w "/dev/$nom_vg/$nom_vl" >/dev/null
	if [ $? -ne 0 ]; then
		# Crea el volumen logico		
		sudo lvcreate -L "$tam" --name "$nom_vl" "$nom_vg" &>/dev/null	
		[[ $? -ne 0 ]] && echo "No se ha podido crear el volumen logico $nom_vl" && exit 1
		# Da formato al volumen lógico
		sudo mkfs -t "$tipo_sf" "/dev/$nom_vg/$nom_vl"	&>/dev/null
		# Comprueba que el directorio de montaje existe previamente
		[[ ! -d "$dir_montaje" ]] && sudo mkdir "$dir_montaje"
		# Monta el volumen
		sudo mount -t "$tipo_sf" "/dev/$nom_vg/$nom_vl" "$dir_montaje"	&>/dev/null	
		# Guarda el UUID
		UUID=$(sudo blkid | grep "/$nom_vg-$nom_vl:" | cut -d'"' -f2)		
		# Edita el fichero /etc/fstab para que se monte en el arranque
		sudo sed -i "\$a UUID=$UUID $dir_montaje $tipo_sf defaults 0 2" /etc/fstab
	else
		# Extiende el volumen logico
		sudo lvextend -L+"$tam" "/dev/$nom_vg/$nom_vl" &>/dev/null	# Agranda el volumen logico
		sudo resize2fs "/dev/$nom_vg/$nom_vl" &>/dev/null		# Agranda el sistema de ficheros
	fi
done<"$1"
# Devuelve el caracter delimitador inicial a IFS
IFS="$old_IFS"
