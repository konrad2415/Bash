#!/bin/bash
( set -e
# Leer la interfaz de red enx activa en el sistema mediante "ip link show"
active_interface=$(ip link show | awk '/enx[0-9a-fA-F:]+/ {gsub(/:/, "", $2); print $2}')

# Función para obtener el estado y dirección IP de una interfaz
function get_interface_status() {
    interface_info=$(ip address show dev "$1")
    interface_state=$(echo "$interface_info" | awk '/state/ {print $9}')
    interface_ip=$(echo "$interface_info" | awk '/inet / {print $2}')
    echo "Device: $1 - Estado: $interface_state - IP: $interface_ip"
}

# Funcion elimminar intrface en el archivo de configuracion /etc/networking/interface
# Esta funcion solo eliminara configuraciones de 2 lineas con peticion de ip por dhcp
function eliminar_interface() {
    interface="$1"
    # Usar sed para eliminar las líneas correspondientes en el archivo
    sed -i "/^auto $interface$/,/^iface $interface inet/d" /etc/network/interfaces
}


# Mostrar la interfaz enx activa en el sistema con su estado e IP si corresponde
get_interface_status "$active_interface"

echo

# Leer todas las interfaces de red de tipo enx almacenadas en /etc/network/interfaces
interfaces_file="/etc/network/interfaces"
declare -a stored_interfaces

while read -r line; do
    if [[ $line =~ enx[0-9a-fA-F:]+ ]]; then
        interface=$(echo "$line" | awk '{gsub(/:/, "", $2); print $2}')
        stored_interfaces+=("$interface")
    fi
done < "$interfaces_file"

# Eliminar duplicados de la lista de interfaces almacenadas
unique_interfaces=($(echo "${stored_interfaces[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

# Mostrar interfaces pendientes por eliminación
echo "Interfaces de red pendientes por eliminación:"
echo

for interface in "${unique_interfaces[@]}"; do
    if [[ "$interface" != "$active_interface" ]]; then
        echo "Eliminada interface: $interface"
        # Eliminando la configuracion de la interface 
       eliminar_interface $interface
    fi
done
)
