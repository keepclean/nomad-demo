# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/stretch64"

  # setup DMs
  (1..3).each do |i|

    config.vm.define "8dm#{i}" do |node|
      node.vm.hostname = "8dm#{i}"
      node.vm.network "private_network", ip: "10.0.0.#{i + 1}", :adapter => 2

      node.vm.provider "virtualbox" do |vb|
        vb.name = "8dm#{i}"
        vb.memory = "512"
        vb.cpus = "1"
        vb.default_nic_type = "virtio"
      end

      # node.vm.synced_folder "salt/", "/srv/salt/", type: "nfs"

      config.vm.provision :salt do |salt|
        salt.install_master = true
        salt.run_highstate = true
        salt.run_overstate = false
        salt.orchestrations = false
        salt.master_config = "configs/master"
        salt.minion_config = "configs/minion"
        salt.minion_id = "8dm#{i}"
        salt.bootstrap_options = "-x python3"

        salt.python_version = "3"
      end

    end

  end
end
