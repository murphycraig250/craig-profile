def supported_linux
  on_supported_os({
    supported_os: [
      {
        'operatingsystem'        => 'Debian',
        'operatingsystemrelease' => ['11', '12'],
      },
      {
        'operatingsystem'        => 'RedHat',
        'operatingsystemrelease' => ['8', '9'],
      },
    ]
  })
end
