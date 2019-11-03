#!/bin/bash


for n in Feder Fassung Pad Base Dorn; do 
	echo "exporting $n"
	echo -e "use <RotateMount.scad>\n$n();\n" > temp.scad
	openscad -o RotateMount_$n.3mf temp.scad
	openscad -o RotateMount_$n.png --viewall --autocenter temp.scad

done
