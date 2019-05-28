server {
    bind_addr = "{{ GetPrivateInterfaces | include \"network\" \"10.0.0.0/24\" | attr \"address\"}}"
    enabled = true
    bootstrap_expect = 3
}
