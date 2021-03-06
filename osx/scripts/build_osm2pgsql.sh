source MacOSX.sh

mkdir -p ${PACKAGES}
cd ${PACKAGES}

download geos-${GEOS_VERSION}.tar.bz2
download protobuf-c-${PROTOBUF_C_VERSION}.tar.gz

echo '*building protobuf C*'
rm -rf cd protobuf-c-${PROTOBUF_C_VERSION}
tar xf protobuf-c-${PROTOBUF_C_VERSION}.tar.gz
cd protobuf-c-${PROTOBUF_C_VERSION}
./configure --prefix=${BUILD} --enable-static --disable-shared \
--disable-dependency-tracking
make -j${JOBS}
make install
cd ${PACKAGES}

echo '*building geos*'
export OLD_LDFLAGS=${LDFLAGS}
export LDFLAGS="${STDLIB_LDFLAGS} ${LDFLAGS}"
rm -rf geos-${GEOS_VERSION}
tar xf geos-${GEOS_VERSION}.tar.bz2
cd geos-${GEOS_VERSION}
patch -N configure.in ${PATCHES}/geos-ansi.diff
./configure --prefix=${BUILD} --enable-static --disable-shared \
--disable-dependency-tracking
make -j${JOBS}
make install
cp include/geos/platform.h ${BUILD}/include/geos/
cd ${PACKAGES}
export LDFLAGS=${OLD_LDFLAGS}

echo '*building osm2pgsql*'
export OLD_LDFLAGS=${LDFLAGS}
export LDFLAGS="${LDFLAGS} -lldap -lpam -lssl -lcrypto -lkrb5"
export LDFLAGS="${STDLIB_LDFLAGS} ${LDFLAGS}"
export OSM2PGSQL_TARGET="${STAGING}/osm2pgsql-osx"
export DESTDIR=${OSM2PGSQL_TARGET}
#svn co http://svn.openstreetmap.org/applications/utils/export/osm2pgsql/
cd ${ROOTDIR}/osm2pgsql
# fix 'Could not find a c++ compiler' error on 'conftest.c:11:10: fatal error: 'ac_nonexistent.h' file not found'
patch configure.ac ${PATCHES}/osm2pgsql-configure.diff -N
patch Makefile.am ${PATCHES}/osm2pgsql-datadir.diff -N
make clean
make distclean
./autogen.sh
./configure --prefix=/usr/local \
--with-zlib=${BUILD} \
--with-bzip2=${BUILD} \
--with-geos=${BUILD}/bin/geos-config \
--with-proj=${BUILD} \
--with-protobuf-c=${BUILD} \
--with-postgresql=${BUILD}/bin/pg_config
make
make install
export LDFLAGS="$OLD_LDFLAGS"
unset DESTDIR

# TODO - update version in packproj
/usr/local/bin/freeze ${ROOTDIR}/installer/osm2pgsql/osm2pgsql.packproj

# TODO dump git describe once it is working


# add docs
echo '
osm2pgsql os x binary
---------------------

osm2pgsql is a command line program.

1) Installing

Double click on the "osm2pgsql.pkg" and follow all the prompts.

2) Usage

Open the Terminal.app in /Applications/Utilities and type:

    osm2pgsql

You should see:

    osm2pgsql SVN version 0.81.0 (64bit id space)

    Usage error. For further information see:
	    osm2pgsql -h|--help

This installer placed osm2pgsql at /usr/local/bin/osm2pgsql. You can confirm this
by typing into your terminal:

    which osm2pgsql

You should see:

    /usr/local/bin/osm2pgsql

The installer also put the "default.style" in /usr/local/share/osm2pgsql/default.style.

More usage:

    osm2pgsql -h

Show the version:

    osm2pgsql -v

Import an .osm file named 'test.osm' into a postgres database named 'osm':

    osm2pgsql -d osm  test.osm

' > "${ROOTDIR}/installer/osm2pgsql/build/README.txt"

DMG_VOL_NAME="osm2pgsql"
DMG_NAME="osm2pgsql.dmg"
rm -rf "${ROOTDIR}/installer/osm2pgsql/build/${DMG_NAME}"
hdiutil create \
  "${ROOTDIR}/installer/osm2pgsql/build/${DMG_NAME}" \
  -volname "${DMG_VOL_NAME}" \
  -fs HFS+ \
  -srcfolder "${ROOTDIR}/installer/osm2pgsql/build/"
