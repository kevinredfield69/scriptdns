#!/bin/bash

#Definimos los ficheros de zona directa e inversa del Servidor DNS, a través de variables
zonadirecta=/var/cache/bind/db.kevin.gonzalonazareno.org
zonainversa=/var/cache/bind/db.172.22

#Opcion A: Añadir Dirección IP (A) o Alias (CNAME)
if [ $1 = "-a" ]
then
	#Opcion -DIR: Añadir Dirección IP
	if [ $2 = "-dir" ]
	then
		#Obtiene los 16 bits de hosts de la dirección IP escrita, para añadirlas al fichero de zona inversa
		ip=`echo $4 | cut -d "." -f4`
		ip2=`echo $4 | cut -d "." -f3`
		#Obtiene el nombre del dominio, para poder añadirlos detrás del nombre escrito, para añadirlas a los ficheros de zona directa e inversa
		dominio=`sed -e '/ORIGIN/ !d' $zonadirecta | cut -f2 -s`
		#Añade el registro escrito al fichero de zona directa
		echo "$3	IN	A	$4" >> $zonadirecta
		echo "Añadido zona directa para $3 en el fichero $zonadirecta..."
		sleep 1
		#Añade el registro escrito al fichero de zona inversa
		echo "$ip.$ip2		IN	PTR	$3.kevin.gonzalonazareno.org." >> $zonainversa
		echo "Añadido zona inversa para $4 en el fichero $zonainversa..."
		sleep 1
		#Reinicia el equipo Servidor DNS Bind9
		echo "Reiniciando Servidor DNS Bind9..."
		sleep 3
		systemctl restart bind9 >> /dev/null

	#Opción Alias: Añadir Alias
	elif [ $2 = "-alias" ]
	then
		#Añade el alias al fichero de zona directa
		echo "$3	IN	CNAME	$4" >> $zonadirecta
		echo "Añadido alias $3 en el fichero $zonadirecta..."
		sleep 1
		#Reinicia el equipo Servidor DNS Bind9
		echo "Reiniciando Servidor DNS Bind9..."
		sleep 3
		systemctl restart bind9 >> /dev/null
	else
		#Salta expeción si no se introduce los parámetros correctos
		echo "Los parametros introducidos no son correctos..."
	fi

#Opción B: Borrar registro en zona directa e inversa
elif [ $1 = "-b" ]
then
        #Obtiene el dominio y el tipo de registro, para poder eliminar correctamente el registro en ambas zonas
	dominio=`sed -e '/ORIGIN/ !d' $zonadirecta | cut -f2 -s`
        registro=`sed -e '/'${2}'/ !d' $zonadirecta | cut -f3 -s`
	echo "Eliminando el registro $2..."
	sleep 1
        #Borra el registro de la zona directa
        sed -i '/'${2}'/d' $zonadirecta
        #Si el registro es de tipo CNAME, no existe dentro de la zona inversa. Sin embargo, si el resgistro de tipo A, lo borra también de la zona inversa
        if [ "$registro" = "A" ]
        then
                sed -i '/'${2}.${dominio}'/d' $zonainversa
	fi
	echo "Reiniciando Servidor DNS Bind9..."
	sleep 3
else
	#Salta excepción si no se escribe los parámetros correctamente
	echo "Los parámetros introducidos no son correctos..."
fi
