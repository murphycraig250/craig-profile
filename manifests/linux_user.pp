class profile::linux_user {
    include accounts 
        accounts::user { 'bradley': 
            locked => false,
            groups => [
                'users',
            ],
            shell  => '/bin/bash',
            sshkeys => [
                'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCi43iIOtL6NjRIKxGNaf6k6N8I+qvnCCcEdgWMK/Qkw5audbOBBkb1CLEwdDmqZojUoYLYotDJtQKze/g7wL8aIz19WDCU8et8jyX+WZN3wTU79rS5oLwpDvTKA791wyUNc+42TJHQbvv5kDJHo0OZXH/z+AuOMOyLHbKYtUs3O4iC0kqYDZbwPVK4dgbH3+q+Zs+ve8SsPCOfzGLQclC9JdBfWAvBak/NyV2Qf+Out3bzI5bV8DS/SjMFiPZ65BNalcvkfFtObjvg5HtaGDpUbKE/uCkCutC3g6lRtZcIKVuNjx9o06171z31bb3KQCxf/6Hu12KWCJBhk71oGmRyMCp0G1w/gEQNHNyAP/OVOGFp9VD0qz/Eqy7AM8mPfer8ibwxlkyPT5Q7AnAe1+g07PlJ/mEKxjXxGvaUPJfkefrYc3WBXUlSprD+uD7OT7fV1YUq6DgVVWA6teQ0JnCFlWvVF4R8WSvF9oQa0ksCd9WkoX0OjCiJXimoNR3WygsAdM7tZaKZUsFVQRG6Kjx73uxkRtVDEiM8MRw+H0G3Cimrg1/OsMVIakIpk9HgWnzJtCp7+5D+co95h4abIP3C7W5T0YjYR2v/o1IVdb4W4giSp2S+oBJN5TDTWaAYs4H2wqhrgjUOQc9qx3eb2/In5gUWeICPCVNt9p6PQQ8JZQ== craig@cm-pc'
            ]
        }
        accounts::user { 'lucas': 
            password => '$6$gfPtUzuaQGcWC/fJ$96SzKL41OBUi8P8ckM.Nx8G5or2nMQP1VcGOQ7csw1gd4jtNIWyZar6/YcyyvJSy6NIvyrSjGnZK74qT6AZQc0',
            locked   => false,
            groups   => [
                'users',
            ],
            shell    => '/bin/bash',
        }
        accounts::user { 'theo': }
    }
