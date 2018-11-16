#!/bin/bash

zonadirecta=db.kevin.gonzalonazareno.org
zonainversa=db.172.22

if [ $1 = "-a" ]
then
	if [ $2 = "-dir" ]
	then
		ip=`echo $4 | cut -d "." -f3,4`
		dominio=`sed -e '/ORIGIN/ !d' $zonadirecta | cut -d " " -f2
		echo "$3	IN	A	$4" >> $zonadirecta
		echo "Añadido $3	IN	A	$4 en el fichero $zonadirecta..."
		sleep 1
		echo "$ip	IN	PTR	$3.$dominio" >> $zonainversa
		echo "Añadido $ip	IN	PTR	$3.$dominio en el fichero $zonainversa..."
		sleep 1
		echo "Reiniciando Servidor DNS Bind9"
		sleep 3
		systemctl restart bind9 >> /dev/null

	elif [ $2 = "-alias" ]
	then
		echo "$3	IN	CNAME	$4" >> $zonadirecta
		echo "Añadido alias	$3	IN	CNAME	$4 en el fichero $zonadirecta..."
		sleep 1
		echo "Reiniciando Servidor DNS Bind9"
		sleep 3
		systemctl restart bind9 >> /dev/null
	else
		echo "Los parametros que has introducido no son correctos."
	fi
elif [ $1 = "-b" ]
then
        dominio=`sed -e '/ORIGIN/ !d' $zonadirecta | cut -d" " -f2`
        registro=`sed -e '/'${2}'/ !d' $zonadirecta | cut -f3 -s`
        sed -i '/'${2}'/d' $zonadirecta
        if [ "$registro" = "A" ]
        then
                sed -i '/'${2}.${dominio}'/d' $zonainversa
        fi
	systemctl restart bind9 >> /dev/null
fi
