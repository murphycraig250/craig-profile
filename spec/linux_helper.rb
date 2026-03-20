def supported_linux
  on_supported_os({
    supported_os: [
      { 'osfamily' => 'Debian' },
      { 'osfamily' => 'RedHat' },
    ]
  })
end