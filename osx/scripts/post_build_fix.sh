set -e

echo "...fixing install names of mapnik and dependencies"

mkdir -p ${MAPNIK_INSTALL}/share/
mkdir -p ${MAPNIK_INSTALL}/share/icu
# TODO - replace with actual icu version
cp ${BUILD}/share/icu/*/icudt*.dat ${MAPNIK_INSTALL}/share/icu/
cp -r ${BUILD}/share/proj ${MAPNIK_INSTALL}/share/
#cp -r ${BUILD}/share/gdal ${MAPNIK_INSTALL}/share/

install_name_tool -id ${MAPNIK_INSTALL}/lib/libmapnik.dylib ${MAPNIK_INSTALL}/lib/libmapnik.dylib


# py2cairo
for i in {"2.6","2.7"}
do
    if [ -d "${BUILD}/lib/python${i}/site-packages/cairo" ];then
        cp -R ${BUILD}/lib/python${i}/site-packages/cairo ${MAPNIK_INSTALL}/lib/python${i}/site-packages/
    fi
done

# fixup plugins
for i in $(ls ${MAPNIK_INSTALL}/lib/mapnik/input/*input)
do
  install_name_tool -change libmapnik.dylib @loader_path/../../libmapnik.dylib ${i}
done

# fixup c++ programs
install_name_tool -change libmapnik.dylib ${MAPNIK_INSTALL}/lib/libmapnik.dylib ${MAPNIK_SOURCE}/demo/c++/rundemo
#install_name_tool -change libmapnik.dylib @loader_path/../lib/libmapnik.dylib ${MAPNIK_INSTALL}/bin/pgsql2sqlite
#install_name_tool -change libmapnik.dylib @loader_path/../lib/libmapnik.dylib ${MAPNIK_INSTALL}/bin/svg2png
for i in $(ls ${MAPNIK_SOURCE}/tests/cpp_tests/*-bin);
do install_name_tool -change libmapnik.dylib ${MAPNIK_INSTALL}/lib/libmapnik.dylib $i;
done

# fixup python

for i in {"2.6","2.7"}
do
    if [ -d "${MAPNIK_INSTALL}/lib/python${i}/site-packages/mapnik" ];then
        install_name_tool -change libmapnik.dylib @loader_path/../../../libmapnik.dylib ${MAPNIK_INSTALL}/lib/python${i}/site-packages/mapnik/_mapnik.so
    fi
done

# cleanups
find ${MAPNIK_INSTALL} -name ".DS_Store" -exec rm -f {} \;
