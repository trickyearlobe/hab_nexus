pkg_origin=trickyearlobe
pkg_name="nexus"
pkg_maintainer="Richard Nixon <richard.nixon@btinternet.com>"
pkg_description="Sonatype Nexus Reposiroty Manager"
pkg_upstream_url="https://www.sonatype.com"

pkg_license=("Apache-2.0")

pkg_major="3"
pkg_minor="24"
pkg_patch="0"
pkg_rev="02"
pkg_version="${pkg_major}.${pkg_minor}.${pkg_patch}"
pkg_fq_version="${pkg_version}-${pkg_rev}"

pkg_filename="nexus-${pkg_version}-unix.tar.gz"
pkg_source="https://sonatype-download.global.ssl.fastly.net/repository/downloads-prod-group/${pkg_major}/nexus-${pkg_fq_version}-unix.tar.gz"
pkg_shasum="a2bfbc602228adeeb1a932e6e79bebea0ca2a9c1e7c86dfeeb3898aebf31f70c"

# Dependencies
pkg_deps=(core/jre8)

# Paths to the application
pkg_bin_dirs=(nexus-$pkg_fq_version/bin)
pkg_lib_dirs=(nexus-$pkg_fq_version/lib)

pkg_exports=(
  [port]=port
)
pkg_exposes=(port)

# Don't run Nexus as root !!!
pkg_svc_user="hab"
pkg_svc_group="$pkg_svc_user"

do_build() {
  return 0
}

do_install() {
  # Copy across the Nexus binaries
  cp -R $HAB_CACHE_SRC_PATH/nexus-$pkg_fq_version $pkg_prefix

  # Then copy across the template sonatype-work directory. We'll use this to construct the default repo
  # under /hab/svc which will persist across upgrades.
  cp -R $HAB_CACHE_SRC_PATH/sonatype-work $pkg_prefix

  # Remove default config file and symlink it to dynamic config
  rm $pkg_prefix/nexus-$pkg_fq_version/bin/nexus.vmoptions
  ln -s /hab/svc/nexus/config/nexus.vmoptions $pkg_prefix/nexus-$pkg_fq_version/bin/nexus.vmoptions
  return 0
}

