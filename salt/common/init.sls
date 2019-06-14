remove preinstalled packages:
  pkg.removed:
    - pkgs:
      - netcat

install common packages:
  pkg.latest:
    - pkgs:
      - curl
      - netcat-openbsd
      - tmux
      - tree
      - vim
