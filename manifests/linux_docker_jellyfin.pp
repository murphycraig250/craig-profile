# Manages Docker whoami service deployment
#
# This profile configures and deploys the whoami Docker application
# with appropriate compose configuration and file permissions.
#
#
class profile::linux_docker_jellyfin {
  profile::linux_docker_app { 'jellyfin':
  }
}
