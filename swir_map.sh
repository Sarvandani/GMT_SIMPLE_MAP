#!/bin/sh
## dar terminal az dastoore sh swir_map.sh file ro ejra mikonim.
#file az linke zir download shavad: https://www.gebco.net/data_and_products/gridded_bathymetry_data/, esme file ------>>>> netCDF
#(4 Gbytes, 7.5 Gbytes uncompressed)
stations=station_list.txt
REG='-R64.25/64.85/-28.30/-27.75'
#Mercator projection (-Jm -JM)
#https://docs.generic-mapping-tools.org/6.0/cookbook/map_projections.html
PROJ='-JM13.8'
#colorchange jet, seafloor, polar, hot
#https://docs.generic-mapping-tools.org/latest/_images/GMT_App_M_1b.png
#reverse color by adding -I
#gmt makecpt -Cocean -T-5500/-1500/500 -I > mycolor.cpt
#smoothing the map by last value -T-5500/-1500/100
gmt makecpt -Cjet -T-5500/-1500/300 > mycolor.cpt
##download bathymetry data by: https://www.gebco.net/data_and_products/gridded_bathymetry_data/ ------>>>> netCDF
#(4 Gbytes, 7.5 Gbytes uncompressed)
gmt grdimage GEBCO_2020.nc -X6 -Y4 $PROJ $REG -Ba0.25f0.25 -W1p  -K -Cmycolor >> map.ps
#D and w are related to the location and size of colorbar.
gmt psscale -D16/0+w14/0.5 -Cmycolor.cpt -Ba500f500+l'Depth(m)' -O -K >> map.ps
#we need file1 for putting stations on the map
#to chnage the symbol, we can use the link below: https://docs.generic-mapping-tools.org/latest/psxy.html
awk '{print $3,$2,$1}' $stations > file1
#plot station names
gmt psxy file1 $PROJ $REG -Si0.8  -O -K -Gblack -W >> map.ps
# we can change size of text on the map.
awk '{ print $1, $2-0.016, 10, 0, 1, 10, $3 }' file1 |
gmt pstext $PROJ $REG -B0 -G255/255/255 -W -O -K  >> map.ps
