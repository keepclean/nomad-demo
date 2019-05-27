job "example" {
    datacenters = ["ru-central1-b"]
    type = "system"
    task "example" {
        driver = "exec"

        config {
            command = "/opt/nomad/tasks/bin/hello-world"
        }

        artifact {
            source = "http://deb9-01.ru-central1.internal:8080/hello-world"
            mode = "file"
            destination = "/opt/nomad/tasks/bin/hello-world"
        }

        resources {
            cpu    = 100 # 100 MHz
            memory = 56 # 56MB
            network {
                mbits = 10
            }
        }
    }
}
