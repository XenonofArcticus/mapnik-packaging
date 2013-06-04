set -e
echo '...packaging DMG'
#install_name_tool -id ${MAPNIK_BIN_SOURCE}/lib/libmapnik.dylib ${MAPNIK_BIN_SOURCE}/lib/libmapnik.dylib
rm -f ${ROOTDIR}/installer/*dmg
rm -rf ${ROOTDIR}/installer/build/*pkg
freeze ${ROOTDIR}/installer/Mapnik.packproj
FOUND_VERSION=`${MAPNIK_BIN_SOURCE}/bin/mapnik-config --version`
MAPNIK_DMG_VOL_NAME="Mapnik ${FOUND_VERSION}"
MAPNIK_DMG_NAME="${MAPNIK_PACKAGE_PREFIX}-osx-v${FOUND_VERSION}.dmg"
hdiutil create \
  "${ROOTDIR}/installer/${MAPNIK_DMG_NAME}" \
  -volname "${MAPNIK_DMG_VOL_NAME}" \
  -fs HFS+ \
  -srcfolder ${ROOTDIR}/installer/build
# upload
UPLOAD="s3://mapnik/dist/v${FOUND_VERSION}/${MAPNIK_DMG_NAME}"
/usr/local/bin/s3cmd --acl-public put "${ROOTDIR}/installer/${MAPNIK_DMG_NAME}" ${UPLOAD}
