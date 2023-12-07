{
  config,
  pkgs,
  ...
}: {
  networking.hostName = "Pix";
  environment.variables.HOSTNAME = "Pix";

  age.secrets.ddns.file = ../../../secrets/ddns.age;

  environment.systemPackages = with pkgs; [
    compsize
    duperemove
    smartmontools
    xxd
  ];

  networking.firewall = {
    allowedTCPPorts = [7455 1010 1011 1012 8080 8081 8082 22122 56450 56451];
    allowedUDPPorts = [8080 1010 1011 1012 8081 8082];
  };

  fileSystems = {
    "/mnt/drive1" = {
      device = "/dev/disk/by-uuid/fc102db2-60b8-43e1-8b21-40a589edfdda";
      fsType = "btrfs";
      options = ["x-systemd.automount" "noauto"];
    };
    "/mnt/drive3" = {
      device = "/dev/disk/by-uuid/6a03c0f9-5c76-4a08-9091-aba7239a6429";
      fsType = "btrfs";
      options = ["x-systemd.automount" "noauto"];
    };
  };

  systemd = {
    timers."update-ddns" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "1m";
        OnUnitActiveSec = "6h";
        Unit = "update-ddns.service";
      };
    };
    services."update-ddns" = {
      script = ''
        TOKEN="$(head -n1 ${config.age.secrets.ddns.path})"
        ZONES="$(tail -n+2 ${config.age.secrets.ddns.path})"
        for ZONE in $ZONES; do
          ${pkgs.curl}/bin/curl -4Lv "https://ipv4.dynv6.com/api/update?ipv4=auto&token=$TOKEN&zone=$ZONE"
        done
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };

  services.nfs.server.exports = ''
    /mnt/drive1 localhost(rw,sync,no_subtree_check,no_root_squash)
    /mnt/drive3 localhost(rw,sync,no_subtree_check,no_root_squash)
    /mnt/drive1 192.168.0.101(rw,sync,no_subtree_check,no_root_squash)
    /mnt/drive3 192.168.0.101(rw,sync,no_subtree_check,no_root_squash)
  '';

  services.samba = {
    securityType = "user";
    extraConfig = ''
      create mask = 644
      directory mask = 755
      force group = users
      force user = snowflake
      map to guest = bad user
      workgroup = WORKGROUP

      valid users = snowflake
    '';
    shares = {
      printers = {
        path = "/var/spool/samba";
        "create mode" = 0700;
        "valid users" = "snowflake";
        browseable = "yes";
        comment = "All Printers";
        printable = "yes";
        writeable = "no";
      };
      drive1 = {
        path = "/mnt/drive1";
        "follow symlinks" = "yes";
        "valid users" = "snowflake";
        browseable = "yes";
        writeable = "yes";
      };
      drive3 = {
        path = "/mnt/drive3";
        "follow symlinks" = "yes";
        "valid users" = "snowflake";
        browseable = "yes";
        writeable = "yes";
      };
    };
  };
  systemd.tmpfiles.rules = [
    "d /var/spool/samba 1777 root root -"
  ];
}
