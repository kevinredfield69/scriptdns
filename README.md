# scriptdns

Nos gustaría poder dar de alta nuevos nombres en el servidor DNS. Para ello vas a crear un scipt en python que nos permita añadir o borrar registros en las zonas de nuestro servidor.

El script se debe llamar gestionDNS.py y recibe cutro parámetros:

	-a o -b: Si recibe -a añadirá un nuevo nombre, si recibe -b borrará el nombre que ha recibido.
	-dir o -alias, si recibe -dir va a crear un registro tipo A, si recibe -alias va a crear un registro CNAME
	El nombre de la máquina para añadir o borrar
	El nombre del alias o la dirección ip: Si has usuado la opción -dir recibirá una ip y si has usuado -alias recibirá el nombre de la máquina a la que le vamos a hacer el alias. Si has utilizado -b no teendrá este parámetro.

Ejemplos:

# Crear el registro -> smtp A 192.168.4.1

gestionDNS.py -a -dir smtp 192.168.4.1

# Crear el registro -> correo CNAME smtp

gestionDNS.py -a -alias correo smtp

# Borrar el último registro

gestionDNS.py -b correo

Todos los registros creados o borrados pertenecen a las zonas tu_nombre.gonzalonazareno.org. Se debe modificar la zona inversa en los casos necesarios. El script debe reiniciar el servidor bind9.
