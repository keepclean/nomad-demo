bind_addr = "{{ GetPrivateInterfaces | exclude \"network\" \"10.0.2.0/24\" | attr \"address\"}}"

server {
    enabled = true
    bootstrap_expect = 1
}
