FROM centos:7
MAINTAINER Amber Yust <amber.yust@gmail.com>

# Grab latest security updates etc
RUN yum -y update && yum clean all

# This dockerfile expects you to have dropped in the headless server tarball
# in the same directory.
ADD factorio_headless_x64_*.tar.gz /opt
ADD run_headless.sh /opt/factorio/
ADD map-gen-settings.json /opt/factorio/

WORKDIR /opt/factorio
CMD ["/opt/factorio/run_headless.sh"]

# The default Factorio server port
EXPOSE 34197/udp
