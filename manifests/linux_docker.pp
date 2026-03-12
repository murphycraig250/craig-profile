# @summary Installs and configures Docker and Docker Compose
#
# This class ensures that Docker and the Docker Compose V2 plugin are installed 
# and that the Docker service is running and enabled on Linux systems.
#
# @example
#   include profile::linux_docker
class profile::linux_docker {
  class { 'docker':
    dns => '8.8.8.8',
  }
}
