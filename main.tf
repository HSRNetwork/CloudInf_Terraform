# TODO: Create the provider for digitalocean
# You have to define the token variable for the API token you created
provider {}

# TODO: Create the ssh key on digitalocean
# You have to define the following variables: name, public_key
resource "digitalocean_ssh_key" "default" {}

# TODO: Add a digitalocean tag with the name "docker_swarm_public"
resource {}

# TODO: Create the docker swarm manager
# You have to define the following variables: name, tags, region, size, image, ssh_keys, private_networking
resource "digitalocean_droplet" "docker_swarm_manager" {

  # TODO: Execute the script install-docker.sh on the master server
  # you have to create a provisioner and configure a connection (type and host)
  provisioner  {
    connection {}
  }

  # TODO: Execute the following command
  # <docker swarm init --advertise-addr ${digitalocean_droplet.docker_swarm_manager.ipv4_address_private}>
  # you have to create a provisioner and configure a connection (type and host)
  provisioner {
    connection {}
  }
}

# TODO: Create an external data ressource for the program join-token.sh
# You have to define the following variables: program, query
# The variables query defines on which host the program will be executed
data "external" "swarm_join_token" {}

# TODO: Create the docker swarm workers
# You have to deploy 3 instances
# The names should be "docker-swarm-worker-0, docker-swarm-worker-1 docker-swarm-worker-2"
# You have to define the following variables: count, name, tags, region, size, image, ssh_keys, private_networking
resource "digitalocean_droplet" "docker_swarm_worker" {

  # TODO: Execute the script install-docker.sh on the worker servers
  # you have to create a provisioner and configure a connection (type and host)
  # Hint: Be aware that when you configure the connection you have to specify on which host it will execute the command (you have 3 hosts)
  provisioner {
    connection {}
  }

  # TODO: Execute the following command
  # <docker swarm join --token ${data.external.swarm_join_token.result.worker} ${digitalocean_droplet.docker_swarm_manager.ipv4_address_private}:2377>
  # you have to create a provisioner and configure a connection (type and host)
  # Hint: Be aware that when you configure the connection you have to specify on which host it will execute the command (you have 3 hosts)
  provisioner {
    connection {}
  }
}

# TODO: Create a simple loadbalancer for the docker swarm cluster
# You have to define the following variables: name, region, droplet_tag
resource "digitalocean_loadbalancer" "public" {

  # TODO: Configure the forwarding rules for the loadbalancer
  # To keep it simple we will forward only port 80 and the http protocol
  # You have to define the following variables: entry_port, entry_protocol, target_port, target_protocol
  forwarding_rule {}

  healthcheck {
    port = 22
    protocol = "tcp"
  }
}
