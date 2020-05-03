#!/bin/bash
#735576, Briones Yus, Patricia, T, 1, A
#757024, Garcés Latre, Germán, T, 1, A

# Cojer direccion ip del primer parametro
[[ $# -ne 1 ]] && echo "Usage: bash practica5_parte2.sh ip_address" && exit 1

ip="$1"

# Comprobar que es una direccion ip valida
[[ ! $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && echo "Invalid ip address" && exit 1

# Comprobar disponibilidad
[[ ! "ping -c 1 $ip" ]] && echo "Host down" && exit 1

# sed: $ representa la ultima linea, d representa delete
hd=$(ssh as@${ip} sudo sfdisk -s)
echo -e  "\nDiscos:\t Tamanyo:\n-------------------"
echo "${hd}" | sed '$d'

echo -e "\nPart.:\t Tamanyo:\n-------------------"
partitions=$(ssh as@${ip} sudo sfdisk -l)
echo "${partitions}" | grep ^/dev | awk '{ if ( $2=="*" ) { print $1,$6 } else { print $1,$5 } }'

sf=$(ssh as@${ip} df -hT)
echo -e "\n${sf}" | grep -v tmpfs
echo -e "\n"
