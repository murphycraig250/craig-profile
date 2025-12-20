class profile::linux_cron {
  include cron

  cron::job { 'datetemp':
    minute  => '5',
    user    => 'root',
    command => '/bin/date >> /tmp/cron',
  }
}
