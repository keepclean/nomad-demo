# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
mkdir -p /etc/salt/minion.d
echo "master:\n  - 10.0.$1.2" > /etc/salt/minion.d/master.conf
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "debian/stretch64"

  ["dm", "m"].each_with_index do |t, i|
    [8, 18].each do |d|
      if "#{t}" == "dm"
        if not File.exists?("configs/keys/#{d}dm-master.pem")
          system( "openssl genpkey -algorithm RSA -out configs/keys/#{d}dm-master.pem -pkeyopt rsa_keygen_bits:2048" )
          system( "openssl rsa -pubout -in configs/keys/#{d}dm-master.pem -out configs/keys/#{d}dm-master.pub" )
        end
      end

      if not File.exists?("configs/keys/#{d}#{t}1-minion.pem")
        system( "openssl genpkey -algorithm RSA -out configs/keys/#{d}#{t}1-minion.pem -pkeyopt rsa_keygen_bits:2048" )
        system( "openssl rsa -pubout -in configs/keys/#{d}#{t}1-minion.pem -out configs/keys/#{d}#{t}1-minion.pub" )
      end

      config.vm.define "#{d}#{t}1" do |node|
        node.vm.hostname = "#{d}#{t}1"
        node.vm.network "private_network", ip: "10.0.#{d}.#{i + 2}", :adapter => 2

        node.vm.provider "virtualbox" do |vb|
          vb.name = "#{d}#{t}1"
          vb.memory = "512"
          vb.cpus = "1"
          vb.default_nic_type = "virtio"
        end

        node.vm.provision "shell" do |s|
          s.inline = $script
          s.args   = "#{d}"
        end

        node.vm.provision :salt do |salt|
          salt.minion_id = "#{d}#{t}1"
          salt.minion_config = "configs/minion"
          salt.minion_key = "configs/keys/#{d}#{t}1-minion.pem"
          salt.minion_pub = "configs/keys/#{d}#{t}1-minion.pub"

          salt.run_highstate = false
          salt.run_overstate = false
          salt.orchestrations = false
          salt.bootstrap_options = "-x python3"
          salt.python_version = "3"

          if "#{t}" == "dm"
            salt.install_master = true
            salt.master_config = "configs/master"
            salt.master_key = "configs/keys/#{d}dm-master.pem"
            salt.master_pub = "configs/keys/#{d}dm-master.pub"
            salt.seed_master = {
              "#{d}dm1": "configs/keys/#{d}dm1-minion.pub",
              "#{d}m1": "configs/keys/#{d}m1-minion.pub",
            }
          end # if
        end # salt
      end # node
    end # d-loop
  end # t-loop
end # config
