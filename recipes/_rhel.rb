build_packages = %w(
  libacl-devel
  libcap-devel
  libcurl-devel
  libgcrypt-devel
  libselinux-devel
  libxml2-devel
  libxslt-devel
  make
  openldap-devel
  pcre-devel
  perl-XML-Parser
  perl-XML-XPath
  perl-devel
  python-devel
  rpm-devel
  swig
  libtool
)

scap_security_guide_packages = %w(
  openscap-utils
  python-lxml
)

other_packages = %w(
  git
)

all_packages = build_packages + scap_security_guide_packages + other_packages

all_packages.each do |pkg|
  package pkg
end
