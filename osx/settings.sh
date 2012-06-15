
export ROOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# available libs:
# /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator5.1.sdk/usr/lib/
# http://stackoverflow.com/questions/8126233/how-to-build-icu-so-i-can-use-it-in-an-iphone-app

XCODE_PREFIX=$( xcode-select -print-path )
# set this up with:
# sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
# man xcrun for more info
#if [[ $XCODE_PREFIX == "/Developer" ]]; then
if [[ -d /Applications/Xcode.app/Contents/Developer ]]; then
    export XCODE_PREFIX="/Applications/Xcode.app/Contents/Developer"
    export CORE_CXX="/usr/bin/clang++"
    export CORE_CC="/usr/bin/clang"
    export AR="${XCODE_PREFIX}/Platforms/iPhoneSimulator.platform/Developer/usr/bin/ar"
    # /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer
    export SDK_PATH="${XCODE_PREFIX}/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator5.1.sdk" ## >= 4.3.1 from MAC
    # http://adcdownload.apple.com/Developer_Tools/auxiliary_tools_for_xcode__february_2012/auxiliary_tools_for_xcode.dmg
    export PATH=${XCODE_PREFIX}/Platforms/iPhoneSimulator.platform/Developer/usr/bin:/Applications/PackageMaker.app/Contents/MacOS/:$PATH
else
    export SDK_PATH="${XCODE_PREFIX}/SDKs/MacOSX10.6.sdk" ## Xcode 4.2
    #export PATH="/Developer/usr/bin:${PATH}"
    export CORE_CXX="/opt/llvm/bin/clang++"
    export CORE_CC="/opt/llvm/bin/clang"
fi

# needed for Coda.app terminal to act sanely
# otherwise various tests fail oddly
#export LANG=en_US.UTF-8

# settings
#export MAPNIK_INSTALL=/opt/mapnik
export MAPNIK_INSTALL="/Library/Frameworks/Mapnik.framework/unix"
export MAPNIK_SOURCE="${ROOTDIR}/mapnik"
export MAPNIK_DIST="${ROOTDIR}/dist"
export PACKAGES="${ROOTDIR}/packages"
export BUILD="${ROOTDIR}/build"
export MAPNIK_PACKAGE_PREFIX="mapnik"
# cd ${MAPNIK_SOURCE}
# MAPNIK_HASH=`git reflog show HEAD | sed -n '1p' | awk '{ print $1 }'`
export MAPNIK_DEV_POSTFIX="-rc3"

export OPTIMIZATION="3"
export JOBS=`sysctl -n hw.ncpu`
if [[ $JOBS > 4 ]]; then
    export JOBS=$(expr $JOBS - 2)
fi
# -arch i386 breaks icu Collator::createInstance
export ARCH_FLAGS="-arch i386"
#export ARCH_FLAGS="-arch x86_64 -arch i386"
export ARCHFLAGS=${ARCH_FLAGS}
export CORE_CPPFLAGS=""
export CORE_CFLAGS="-O${OPTIMIZATION} ${ARCH_FLAGS} -Wc++0x-extensions"
export CORE_CXXFLAGS=${CORE_CFLAGS}
export CORE_LDFLAGS="-O${OPTIMIZATION} ${ARCH_FLAGS} -Wl,-search_paths_first -headerpad_max_install_names"

# breaks distutils
#export MACOSX_DEPLOYMENT_TARGET=10.6
export OSX_SDK_CFLAGS="-miphoneos-version-min=4.3 -isysroot ${SDK_PATH}"
export OSX_SDK_LDFLAGS="-miphoneos-version-min=4.3 -isysroot ${SDK_PATH}"
#export OSX_SDK_LDFLAGS="-mmacosx-version-min=10.6 -Wl,-syslibroot,${SDK_PATH}"
export CXX=${CORE_CXX}
export CC=${CORE_CC}
export CPPFLAGS=${CORE_CPPFLAGS}
export LDFLAGS="-L${BUILD}/lib $CORE_LDFLAGS $OSX_SDK_LDFLAGS"
export CFLAGS="-I${BUILD}/include $CORE_CFLAGS $OSX_SDK_CFLAGS"
export CXXFLAGS="-I${BUILD}/include $CORE_CXXFLAGS $OSX_SDK_CFLAGS"

export DYLD_LIBRARY_PATH="${BUILD}/lib"
export PKG_CONFIG_PATH="${BUILD}/lib/pkgconfig"
export PATH="${BUILD}/bin:$PATH"

# versions
export ICU_VERSION="49.1.1"
export ICU_VERSION2="49_1_1"
export BOOST_VERSION="1.49.0"
export BOOST_VERSION2="1_49_0"
export SQLITE_VERSION="3071200"
export FREETYPE_VERSION="2.4.9"
export PROJ_VERSION="4.8.0"
export PROJ_GRIDS_VERSION="1.5"
export LIBPNG_VERSION="1.5.10"
export LIBTIFF_VERSION="4.0.1"
export LIBGEOTIFF_VERSION="1.4.0"
export JPEG_VERSION="8d"
export GDAL_VERSION="1.9.0"
export GETTEXT_VERSION="0.18.1.1"
export POSTGRES_VERSION="9.1.3"
export ZLIB_VERSION="1.2.7"
export LIBTOOL_VERSION="2.4.2"

# cairo stuff
export PKG_CONFIG_VERSION="0.25"
export FONTCONFIG_VERSION="2.8.0"
# 0.24.4 will not link:
#"_lcg_seed", referenced from:
#      _main in region-test.o     
#export PIXMAN_VERSION="0.24.4"
export PIXMAN_VERSION="0.22.2"
export CAIRO_VERSION="1.12.2"
export CAIROMM_VERSION="1.10.0"
export SIGCPP_VERSION="2.2"
export SIGCPP_VERSION2="2.2.10"
export PY2CAIRO_VERSION="1.10.0"

