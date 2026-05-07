# frozen_string_literal: true

rpc_password = node.dig('transmission_test', 'rpc_password') || 'changeme'

transmission_install 'default'

transmission_config 'default' do
  rpc_password rpc_password
  rpc_bind_address '0.0.0.0'
  rpc_whitelist '127.0.0.1'
end

transmission_service 'default' do
  action %i(create enable start)
end
