class user-mindless {
    group {
        "mindless" :
            ensure  => present;
    }

    user {
        "mindless" :
            gid     => "mindless",
            groups  => "infraadmin",
            shell   => "/bin/bash",
            home    => "/home/mindless",
            ensure  => present,
            require => [
                        Group["mindless"],
                        Group["infraadmin"],
                        ];
    }

    file {
        "/home/mindless" :
            ensure      => directory,
            require     => User["mindless"],
            owner       => "mindless",
            group       => "mindless";
        "/home/mindless/.ssh" :
            ensure      => directory,
            require     => File["/home/mindless"],
            owner       => "mindless",
            group       => "mindless";
    }

    ssh_authorized_key {
        "mindless" :
            user        => "mindless",
            ensure      => present,
            require     => File["/home/mindless/.ssh"],
            key         => "AAAAB3NzaC1yc2EAAAABIwAAAQEA2Xoz+wjGIJPo3V8Hd8Ia2lgWk91V9yDUs1Ibl+RzTTxexDz1uN/emuiqRUAT5EIztDo1LIdAsWeG81hnWZ/+oqxgcbjvLloqroQLcoDJprLOG0j7hmcHYomhIJt1VOuwxlgtzPeKcbKeJbKg90OvJY9pTU3XdGSOL1OXOiJgCqs19uklq1Aex5LCBB8bej/dT/Gu8Pgph4kxCMk17hbLtrXXxQZYB8HDFQAcVTxJwFuuXSLbzZvy1ic97zwLE/T9tWwK6hTpmlUSFE5Qvu37/pNFxtOasn0dK4/+KIlbmhEJ4Ve2LcEzJv4bnKEB/AITFrM3PqDwZng+78HmBq+urQ==",
            type        => "rsa",
            name        => "mindless";
    }
}
