Vagrant::Config.run do |config|
  config.vm.box = "precise32"
  config.vm.network :hostonly, "192.168.50.4"
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "site.pp"
  end
end
