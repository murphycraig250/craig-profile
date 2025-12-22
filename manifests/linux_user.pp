class profile::linux_user {
    include accounts 
        accounts::user { 'bradley': }
        accounts::user { 'lucas': 
            password => '$6$gfPtUzuaQGcWC/fJ$96SzKL41OBUi8P8ckM.Nx8G5or2nMQP1VcGOQ7csw1gd4jtNIWyZar6/YcyyvJSy6NIvyrSjGnZK74qT6AZQc0',
            locked   => false,
            groups   => [
                'users',
            ]
            shell    => '/bin/bash',
        }
        accounts::user { 'theo': }
    }
