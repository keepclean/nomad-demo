job "example" {
    datacenters = ["lhr08"]
    type = "system"
    task "example" {
        driver = "exec"

        config {
            command = "/opt/nomad/tasks/bin/hello-world"
        }

        artifact {
            source = "https://github.com/keepclean/nomad-demo/releases/download/0.01/hello_world_linux_amd64"
            mode = "file"
            destination = "/opt/nomad/tasks/bin/hello-world"
        }

        resources {
            cpu    = 100 # MHz
            memory = 56 # MB
            network {
                mbits = 10
            }
        }
    }
}
