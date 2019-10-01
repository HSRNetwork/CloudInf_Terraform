provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "default" {
  name = "${var.do_key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "digitalocean_tag" "docker_swarm_public" {
  name = "docker-swarm-public"
}

resource "digitalocean_droplet" "docker_swarm_manager" {
  name = "docker-swarm-manager"
  tags = ["${digitalocean_tag.docker_swarm_public.id}"]
  region = "${var.do_region}"
  size = "${var.do_droplet_size}"
  image = "${var.do_image}"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
  private_networking = true

  provisioner "remote-exec" {
    script = "install-docker.sh"

    connection {
      type = "ssh"
      host = "${digitalocean_droplet.docker_swarm_manager.ipv4_address}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm init --advertise-addr ${digitalocean_droplet.docker_swarm_manager.ipv4_address_private}"
    ]

    connection {
      type = "ssh"
      host = "${digitalocean_droplet.docker_swarm_manager.ipv4_address}"
    }
  }
}

data "external" "swarm_join_token" {
  program = ["${path.module}/join-token.sh"]
  query = {
    host = "${digitalocean_droplet.docker_swarm_manager.ipv4_address}"
  }
}

resource "digitalocean_droplet" "docker_swarm_worker" {
  # count = 3
  # name = "docker-swarm-worker-${count.index}"
  name = "docker-swarm-worker"
  tags = ["${digitalocean_tag.docker_swarm_public.id}"]
  region = "${var.do_region}"
  size = "${var.do_droplet_size}"
  image = "${var.do_image}"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
  private_networking = true

  provisioner "remote-exec" {
    script = "install-docker.sh"

    connection {
      type = "ssh"
      host = "${digitalocean_droplet.docker_swarm_worker.ipv4_address}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm join --token ${data.external.swarm_join_token.result.worker} ${digitalocean_droplet.docker_swarm_manager.ipv4_address_private}:2377"
    ]

    connection {
      type = "ssh"
      host = "${digitalocean_droplet.docker_swarm_worker.ipv4_address}"
    }
  }
}

resource "digitalocean_loadbalancer" "public" {
  name = "docker-swarm-public-loadbalancer"
  region = "${var.do_region}"
  droplet_tag = "${digitalocean_tag.docker_swarm_public.name}"

  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"
    target_port = 80
    target_protocol = "http"
  }

  healthcheck {
    port = 22
    protocol = "tcp"
  }
}
