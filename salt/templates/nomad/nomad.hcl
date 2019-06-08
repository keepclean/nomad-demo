region = "{{ pillar['region'] }}"
datacenter = "{{ pillar['datacenter'] }}"
data_dir = "/opt/nomad"

consul {
    address = "127.0.0.1:8500"
    server_service_name = "nomad-server"
    client_service_name = "nomad-client"
    auto_advertise = true
    server_auto_join = true
    client_auto_join = true
}
