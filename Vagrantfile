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
        salt.run_highstate = false
        salt.run_overstate = false
        salt.orchestrations = false
        salt.minion_id = "8dm#{i}"

        salt.master_config = "configs/master"
        salt.master_key = "configs/keys/8dm#{i}.pem"
        salt.master_pub = "configs/keys/8dm#{i}.pub"

        salt.minion_config = "configs/minion"
        salt.minion_key = "configs/keys/8dm#{i}.pem"
        salt.minion_pub = "configs/keys/8dm#{i}.pub"

        salt.seed_master = {
          "8dm1": "configs/keys/8dm1.pub",
          "8dm2": "configs/keys/8dm2.pub",
          "8dm3": "configs/keys/8dm3.pub",
        }

        salt.bootstrap_options = "-x python3"
        salt.python_version = "3"
      end

    end

  end
end
