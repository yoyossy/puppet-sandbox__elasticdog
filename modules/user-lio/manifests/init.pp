class user-lio {
    group {
        "lio" :
            ensure  => present;
    }
    group {
        "cellinfo" :
            ensure  => present;
    }
    user {
        "lio" :
            gid     => "lio",
            groups  => "cellinfo",
            shell   => "/bin/bash",
            home    => "/home/lio",
            ensure  => present,
            require => [
                        Group["lio"],
                        Group["cellinfo"],
                        ];
    }

    file {
        "/home/lio" :
            ensure      => directory,
            require     => User["lio"],
            owner       => "lio",
            group       => "lio";
        "/home/lio/.ssh" :
            ensure      => directory,
            require     => File["/home/lio"],
            owner       => "lio",
            group       => "lio";
    }

    ssh_authorized_key {
        "lio" :
            user        => "lio",
            ensure      => present,
            require     => File["/home/lio/.ssh"],
            key         => "AAAAB3NzaC1yc2EAAAABIwAAAQEA402I3RoTGntFReTPTs5UGO2HkU4UN3PDZ/slALFXRC6qKMhdySzHfIXJTVx8IE7Z/TcBuM411Hy/HwTZFZBihw/B8mD6ubut5py0GUc8sI/Qo7++1qaEjhXg6aLZGqu+USH0aE/fgqzZq1o8YF+HxuN5FhWKsbL3T1ukf387gT6rhuUje4Ch9ko/h40IsIyvpcqVCGo47SfDz+lCT2A0mXp/rtJRYOTGdqLAUcJ1zZNawf7FrxGtphuppgyGYFHT+qq4lRRlgVu6rZrAWWoDPPexGB4XuRrbcgKXZ595WQjpx+zlz6Og5TNX4bvX59MQPKr8cg3Qj842ZfOgPkBvOw==",
            type        => "rsa",
            name        => "lio@lio-laptop";
    }
}
