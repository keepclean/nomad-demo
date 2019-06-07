# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
mkdir -p /etc/salt/minion.d
echo "master: [10.0.$1.2, 10.0.$1.3, 10.0.$1.4]" > /etc/salt/minion.d/master.conf"
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "debian/stretch64"

  # setup DCs
  [8].each do |d|

    dms = [1]

    [1].each do |i|
      if not File.exists?("configs/keys/#{d}dm#{i}.pem")
        system( "openssl genpkey -algorithm RSA -out configs/keys/#{d}dm#{i}.pem -pkeyopt rsa_keygen_bits:2048" )
        system( "openssl rsa -pubout -in configs/keys/#{d}dm#{i}.pem -out configs/keys/#{d}dm#{i}.pub" )
      end
    end

    # setup DMs
    dms.each do |i|

      config.vm.define "#{d}dm#{i}" do |node|
        node.vm.hostname = "#{d}dm#{i}"
        node.vm.network "private_network", ip: "10.0.#{d}.#{i + 1}", :adapter => 2

        node.vm.provider "virtualbox" do |vb|
          vb.name = "#{d}dm#{i}"
          vb.memory = "512"
          vb.cpus = "1"
          vb.default_nic_type = "virtio"
        end

        config.vm.provision "shell" do |s|
          s.inline = $script
          s.args   = "#{d}"
        end

        config.vm.provision :salt do |salt|
          salt.install_master = true
          salt.run_highstate = false
          salt.run_overstate = false
          salt.orchestrations = false
          salt.minion_id = "#{d}dm#{i}"

          salt.master_config = "configs/master"
          salt.master_key = "configs/keys/#{d}dm#{i}.pem"
          salt.master_pub = "configs/keys/#{d}dm#{i}.pub"

          salt.minion_config = "configs/minion_#{d}"
          salt.minion_key = "configs/keys/#{d}dm#{i}.pem"
          salt.minion_pub = "configs/keys/#{d}dm#{i}.pub"

          salt.seed_master = {
            "#{d}dm1": "configs/keys/#{d}dm1.pub",
            "#{d}dm2": "configs/keys/#{d}dm2.pub",
            "#{d}dm3": "configs/keys/#{d}dm3.pub",
          }

          salt.bootstrap_options = "-x python3"
          salt.python_version = "3"
        end

      end

    end

  end
end
