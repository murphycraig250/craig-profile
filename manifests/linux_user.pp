class profile::linux_user {
    include accounts 
        accounts::user { 'bradley': }
        accounts::user { 'lucas': }
        accounts::user { 'theo': }
    }