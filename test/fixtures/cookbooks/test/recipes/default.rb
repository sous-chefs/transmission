apt_update

transmission_install 'tramsission' do
  install_method node['trasmission']['install_method']
end

