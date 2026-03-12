# @summary Manages cron jobs for Linux systems
#
# This class configures periodic cron jobs, including a default date logging job 
# and any additional jobs defined in the 'cron_jobs::create' Hiera lookup.
#
# @example
#   include profile::linux_cron
#
class profile::linux_cron {
  include cron

  $date = $facts['os']['family'] ? {
    'Debian' => '/bin/date',
  'RedHat' => '/usr/bin/date', }

  cron::job { 'datetemp':
    minute  => '*/5',
    user    => 'root',
    command => "${date} >> /tmp/cron",
  }

  $cron_jobs = lookup('cron_jobs::create', Hash, 'deep', {})

  $cron_jobs.each | String $job_name, Hash $attributes| {
    cron::job { $job_name:
      user => 'root',
      *    => $attributes,
    }
  }
}
