#!/bin/bash

# Conversor de decimal a binario
# Los binarios obtenidos empezaran de derecha a izquierda (1-128)
read -p "Introduce una IP " n

IP=$(echo $n | cut -d "/" -f1)
CIDR=$(echo $n | cut -d "/" -f2)
MASCARA=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
count=0
punt=0

for i in {1..4}; do
	dec=$(echo $IP | cut -d  "." -f$i)
	bin=$(echo "obase=2;$dec" | bc)
	echo "$dec -> $bin "
done
hosts=$((32-$CIDR))
echo "Los ultimos $hosts bits corresponden a los hosts"
red=$CIDR
echo "Los primeros $red bits corresponden a la red"

for i in {0..31}; do
	if [ $count -lt $CIDR ]; then
		MASCARA[$i]=1
	else
		MASCARA[$i]=0
	fi
	((count++))
done
echo ${MASCARA[*]}
echo ${!MASCARA[@]}
for z in ${MASCARA[@]}; do
	if [ $punt -eq 7 ]; then
		netmask+=$z.
	elif [ $punt -gt 7 ]; then
		netmask+=$z
		punt=0
	else
		netmask+=$z
	fi
	((punt++))
done

firstOctet=$(echo $netmask | cut -d "." -f1)
firstOctet=$(echo "ibase=2;$firstOctet" | bc)
secondOctet=$(echo $netmask | cut -d "." -f2)
secondOctet=$(echo "ibase=2;$secondOctet" | bc)
thirdOctet=$(echo $netmask | cut -d "." -f3)
thirdOctet=$(echo "ibase=2;$thirdOctet" | bc)
fourthOctet=$(echo $netmask | cut -d "." -f4)
fourthOctet=$(echo "ibase=2;$fourthOctet" | bc)
echo $netmask
echo $firstOctet
echo $secondOctet
echo $thirdOctet
echo $fourthOctet


