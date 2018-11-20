#!/bin/bash

zonadirecta=/var/cache/bind/db.kevin.gonzalonazareno.org
zonainversa=/var/cache/bind/db.172.22

if [ $1 = "-a" ]
then
	if [ $2 = "-dir" ]
	then
		ip=`echo $4 | cut -d "." -f4`
		ip2=`echo $4 | cut -d "." -f3`
		dominio=`sed -e '/ORIGIN/ !d' $zonadirecta | cut -f2 -s`
		echo "$3	IN	A	$4" >> $zonadirecta
		echo "Añadido zona directa para $3 en el fichero $zonadirecta..."
		sleep 1
		echo "$ip.$ip2		IN	PTR	$3.kevin.gonzalonazareno.org." >> $zonainversa
		echo "Añadido zona inversa para $4 en el fichero $zonainversa..."
		sleep 1
		echo "Reiniciando Servidor DNS Bind9..."
		sleep 3
		systemctl restart bind9 >> /dev/null

	elif [ $2 = "-alias" ]
	then
		echo "$3	IN	CNAME	$4" >> $zonadirecta
		echo "Añadido alias	$3	IN	CNAME	$4 en el fichero $zonadirecta..."
		sleep 1
		echo "Reiniciando Servidor DNS Bind9..."
		sleep 3
		systemctl restart bind9 >> /dev/null
	else
		echo "Los parametros introducidos no son correctos..."
	fi
elif [ $1 = "-b" ]
then
        #Obtenemos el dominio y el tipo de registro para poder hacer una correcta elimininación del registro
	dominio=`sed -e '/ORIGIN/ !d' $zonadirecta | cut -f2 -s`
        registro=`sed -e '/'${2}'/ !d' $zonadirecta | cut -f3 -s`
	echo "Eliminando el registro $2..."
	sleep 1
        #Borramos el registro de la zona directa
        sed -i '/'${2}'/d' $zonadirecta
        #Si el registro es de tipo CNAME, no existe dentro de la zona inversa
        if [ "$registro" = "A" ]
        then
                sed -i '/'${2}.${dominio}'/d' $zonainversa
	fi
	echo "Reiniciando Servidor DNS Bind9..."
	sleep 3
else
	echo "Los parámetros introducidos no son correctos..."
fi
