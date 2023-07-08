pkg_origin=trickyearlobe
pkg_name="nexus"
pkg_maintainer="Richard Nixon <richard.nixon@btinternet.com>"
pkg_description="Sonatype Nexus Repository Manager"
pkg_upstream_url="https://www.sonatype.com"

pkg_license=("Apache-2.0")

pkg_major="3"
pkg_minor="57"
pkg_patch="0"
pkg_rev="01"
pkg_version="${pkg_major}.${pkg_minor}.${pkg_patch}"
pkg_fq_version="${pkg_version}-${pkg_rev}"

pkg_filename="nexus-${pkg_version}-unix.tar.gz"
pkg_source="https://sonatype-download.global.ssl.fastly.net/repository/downloads-prod-group/${pkg_major}/nexus-${pkg_fq_version}-unix.tar.gz"
pkg_shasum="d0f29f314399b0143c101ebaffb349596c087e96516b8f321ab045e37caf844d"

# Switch to Corretto8 for JRE due to Oracle license changes
pkg_deps=(core/corretto8)

# Paths to the application
pkg_bin_dirs=(bin)
pkg_lib_dirs=(lib)

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
  echo Copying Nexus binaries from $HAB_CACHE_SRC_PATH/nexus-$pkg_fq_version to $pkg_prefix
  cp -RT $HAB_CACHE_SRC_PATH/nexus-$pkg_fq_version $pkg_prefix

  # Copy across the template sonatype-work directory.
  # We'll use this to construct the default repo under
  # /hab/svc which will persist across upgrades.
  echo Copying $HAB_CACHE_SRC_PATH/sonatype-work to $pkg_prefix
  cp -R $HAB_CACHE_SRC_PATH/sonatype-work $pkg_prefix

  # Update nexus.vmoptions to use the service's data directory.
  sed -i 's/..\/sonatype-work/\/hab\/svc\/nexus\/data\/sonatype-work/g' $pkg_prefix/bin/nexus.vmoptions

  # When we export to docker, hab's home dir is / which is not writable. Java defaults to store
  # preferences in the home directory, so we need to make sure it puts them somewhere else
  grep -q -e '-Djava.util.prefs.userRoot' $pkg_prefix/bin/nexus.vmoptions || echo "-Djava.util.prefs.userRoot=/hab/svc/nexus/data" >> $pkg_prefix/bin/nexus.vmoptions

  return 0
}
