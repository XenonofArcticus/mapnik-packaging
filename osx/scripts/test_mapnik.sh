cd ${MAPNIK_SOURCE}/demo/c++
export DYLD_LIBRARY_PATH=''
export PROJ_LIB=${MAPNIK_INSTALL}/share/proj
export ICU_DATA=${MAPNIK_INSTALL}/share/icu
export GDAL_DATA=${MAPNIK_INSTALL}/share/gdal
export PYTHONPATH=${MAPNIK_INSTALL}/lib/python2.7/site-packages/
export PATH=${MAPNIK_INSTALL}/bin:$PATH
./rundemo

<<COMMENT
export MAPNIK_INSTALL=/Library/Frameworks/Mapnik.framework/unix
export PROJ_LIB=${MAPNIK_INSTALL}/share/proj
export ICU_DATA=${MAPNIK_INSTALL}/share/icu
export GDAL_DATA=${MAPNIK_INSTALL}/share/gdal
COMMENT
