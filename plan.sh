pkg_origin=trickyearlobe
pkg_name="nexus"
pkg_maintainer="Richard Nixon <richard.nixon@btinternet.com>"
pkg_description="Sonatype Nexus Repository Manager"
pkg_upstream_url="https://www.sonatype.com"

pkg_license=("Apache-2.0")

pkg_major="3"
pkg_minor="41"
pkg_patch="1"
pkg_rev="01"
pkg_version="${pkg_major}.${pkg_minor}.${pkg_patch}"
pkg_fq_version="${pkg_version}-${pkg_rev}"

pkg_filename="nexus-${pkg_version}-unix.tar.gz"
pkg_source="https://sonatype-download.global.ssl.fastly.net/repository/downloads-prod-group/${pkg_major}/nexus-${pkg_fq_version}-unix.tar.gz"
pkg_shasum="1ad45fd883f41005e7f89ccb9e504f09a9a5708eb996493b985eed09e6482faa"

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

  # Save nexus.vmoptions in case we want to review it later
  # We will replace it with a symlink to the dynamic config.
  # We do it here because the run hook doesn't have sufficient rights.
  echo Saving $pkg_prefix/bin/nexus.vmoptions
  mv $pkg_prefix/bin/nexus.vmoptions $pkg_prefix/bin/nexus.vmoptions.example
  echo Symlinking $pkg_svc_config_path/nexus.vmoptions to $pkg_prefix/bin/nexus.vmoptions
  ln -s $pkg_svc_config_path/nexus.vmoptions $pkg_prefix/bin/nexus.vmoptions


  # Copy across the template sonatype-work directory.
  # We'll use this to construct the default repo under
  # /hab/svc which will persist across upgrades.
  echo Copying $HAB_CACHE_SRC_PATH/sonatype-work to $pkg_prefix
  cp -R $HAB_CACHE_SRC_PATH/sonatype-work $pkg_prefix

  return 0
}
