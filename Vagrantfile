# -*- mode: ruby -*-
# vi: set ft=ruby :
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  require "pathname"

  config.vm.box = "mightylady/mightybox"
  config.vm.network "private_network", ip: "192.168.44.44"
  config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provision :shell, :path => "vagrant/wp.sh"
  config.vm.synced_folder ".", "/var/www", owner: "vagrant", group: "www-data", mount_options: ['dmode=775', 'fmode=775']

  # handling WordPress imports
  config.trigger.after :up do |trigger|
    trigger.info = "Keeping WordPress databases current."
    trigger.warn = "Catching you up..."
    trigger.run_remote = { path: "vagrant/database/import.sh" }
  end

  # success message
  config.trigger.after :up do |trigger|
    trigger.info = "Last step."
    trigger.warn = "Yessss, we're in."
  end

  # exporting databases
  config.trigger.before :halt do |trigger|
    trigger.info = "Exporting WordPress databases, almost done..."
    trigger.warn = "Saving your changes..."
    trigger.run_remote = { path: "vagrant/database/export.sh" }
  end

  # success message
  config.trigger.after :halt do |trigger|
    trigger.warn = "Mischief managed."
  end
end
