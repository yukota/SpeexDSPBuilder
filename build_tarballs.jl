# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "SpeexDSP"
version = v"1.2.0-rc3"

# Collection of sources required to build SpeexDSP
sources = [
    "http://downloads.xiph.org/releases/speex/speexdsp-1.2rc3.tar.gz" =>
    "4ae688600039f5d224bdf2e222d2fbde65608447e4c2f681585e4dca6df692f1",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd speexdsp-1.2rc3/
./configure --prefix=$prefix --host=$target
make -j${nproc}
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf),
    MacOS(:x86_64),
    FreeBSD(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libspeexdsp", :libspeexdsp)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

