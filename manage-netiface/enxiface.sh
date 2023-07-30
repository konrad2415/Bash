###  Author:  Daibel Inle Martinez Sanchez [Konrad Zuse]
###  E-mail:  konradzuse.dm@gmail.com
###  Date  :  2023-07-28:

### The main objective was to automate the RNDIS usb Alcatel OneTouch L850V / Telekom Speedstick LTE
### Oficially sold by alcatel as "Alcatel Link Zone mw41nf" which ran into isues to give dhcp automatic
### address to my debian 12 bookworm server by usb thethering 
### i solved the isue installing debian "usb-modeswitch" package and handling the attached device with this script
### to verify which interface is attached with the prefix enx paticularly by this debian 12 was discoverde check 
### if it has or not configured IP address and if itss not reques the device for dhcp IPv4 


function restart_interface() {
    # Deshabilitar la interfaz
    sudo ip link set dev "$interface" down

    # Solicitar una dirección IPv4 por DHCP
    sudo dhclient -4 "$interface"

    # Habilitar la interfaz
    sudo ip link set dev "$interface" up

    # Esperar un momento para que la nueva configuración se aplique y obtener la dirección IP
    sleep 5

    # Mostrar la dirección IP asignada
    echo "Dirección IP asignada a la interfaz $interface:"
    ip addr show dev "$interface" | awk '/inet / {print $2}'
}




# Obtener la lista de interfaces de red con prefijo "enx"
enx_interfaces=$(ip link show | awk -F': ' '/^[0-9]+: enx/ {print $2}')

# Verificar si hay interfaces con prefijo "enx"
if [ -z "$enx_interfaces" ]; then
    echo "No se encontraron interfaces de red con prefijo enx."
else
    # Mostrar información y configurar cada interfaz con prefijo "enx"
    for interface in $enx_interfaces; do
        # Obtener la dirección MAC de la interfaz
        mac_address=$(ip link show dev "$interface" | awk '/link\/ether/ {print $2}')

        # Obtener el estado de la interfaz
        state=$(ip link show dev "$interface" | awk '/state/ {print $9}')

        echo "Interfaz de red con prefijo enx detectada: $interface"
        echo "Dirección MAC: $mac_address"
        echo "Estado: $state"

        # Verificar si la interfaz tiene una dirección IP configurada
        ip_address=$(ip -4 addr show dev "$interface" | awk '/inet / {print $2}')
        if [ -z "$ip_address" ]; then
            # Sugerir configuración por DHCP para IPv4 y añadirla al archivo de configuración
            echo "Se aplicara la configuracion en /etc/network/interfaces :"
            echo "auto $interface"
            echo "iface $interface inet dhcp"
            echo

            # Anadir configuracion por DHCP para IPv4 al archivo de configuración
            echo "auto $interface" >> /etc/network/interfaces
            echo "iface $interface inet dhcp" >> /etc/network/interfaces
            echo >> /etc/network/interfaces


            # Configurar el USB-WAN bridge para las VM - por defecto se usara el vmbr2
            # Las configuraciones de los vmbrX solo pueden ser hecas con comandos especificos de 
            # Proxmox VE por lo que los cambios hechos de forma manual con las vmbr no surtiran efecto aun asi 
            # este codigo es util para controlar la interface de red USB

            # echo >> /etc/network/interfaces
            #echo "auto vmbr2"                     >> /etc/network/interfaces
            #echo "iface vmbr2 inet manual"        >> /etc/network/interfaces
            #echo "	bridge-ports $interface"  >> /etc/network/interfaces
            #echo "	bridge-stp off"           >> /etc/network/interfaces
            #echo "	bridge-fd 0"              >> /etc/network/interfaces
            #echo >> /etc/network/interfaces
            # Reiniciar la interfaz de red
            restart_interface

        else
            # Mostrar la dirección IP de la interfaz
            echo "Dirección IP asignada a $interface: $ip_address"
        fi
    done
fi
