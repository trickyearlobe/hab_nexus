pkg_name=nexus
pkg_origin=trickyearlobe
pkg_version="2.14.4-03"

pkg_maintainer="Richard Nixon <richard.nixon@btinternet.com>"
pkg_source="https://sonatype-download.global.ssl.fastly.net/nexus/oss/${pkg_name}-${pkg_version}-bundle.tar.gz"
pkg_shasum="bf5cf479dbd262939017779a7b610119e11f97b0649d875f64dbdfae9e93cf72"
pkg_description="Nexus OSS 2.x artifact repository supporting Maven, P2, OBR, YUM and others"
pkg_upstream_url="https://www.sonatype.com"

# FIXME: Dirty hack because Nexus needs to write its own directories
# Should template the config and move dirs to somewhere writable because
# it doesn't seem possible to change perms in any of the hooks and have them
# survive the 'export to docker'
pkg_svc_user="root"
pkg_svc_group="root"

pkg_deps=(core/glibc core/jdk8/8u111)
pkg_build_deps=(core/psmisc core/patchelf)
pkg_lib_dirs=(nexus-${pkg_version}/lib)
pkg_include_dirs=(nexus-${pkg_version}/include)
pkg_bin_dirs=(nexus-${pkg_version}/bin)

pkg_exports=(
  [port]=nexusport
)

pkg_exposes=(port)

do_build() {
  return 0
}
do_strip() {
  return 0
}

do_install() {
  cp -R $HAB_CACHE_SRC_PATH/nexus-$pkg_version $pkg_prefix
  cp -R $HAB_CACHE_SRC_PATH/sonatype-work $pkg_prefix
  # Fix up the ELF interpreter for "wrapper"
  LD_LINUX_PATH=$(pkg_path_for core/glibc)/lib/ld-linux-x86-64.so.2
  WRAPPER_PATH=$pkg_prefix/nexus-$pkg_version/bin/jsw/linux-x86-64/wrapper
  patchelf --interpreter $LD_LINUX_PATH $WRAPPER_PATH
  return 0
}

do_after() {
  chown -R hab:hab $pkg_prefix/*
}
