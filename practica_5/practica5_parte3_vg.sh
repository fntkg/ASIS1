#!/bin/bash
#735576, Briones Yus, Patricia, T, 1, A
#757024, Garcés Latre, Germán, T, 1, A

[[ $# -lt 2 ]] && echo "Usage: ./practica5_parte3_vg.sh vgName [partitionName]+" && exit 1

vg="$1"

# Comprobar si existe el grupo volumen
! sudo vgs | grep -wq ${vg} && echo "Volume group: ${vg} doesn't exist" && exit 1

shift

for particion in "$@"
do
	# Comprobar que existe
	! sudo fdisk -l | grep -q ^/dev/${particion} && echo "Partition ${particion} doesn't exist" && continue

	sudo vgextend ${vg} /dev/${particion} &/dev/null && echo "Volume group correctly extended" || echo "Error extending volume group"
done
