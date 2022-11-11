resource "docker_container" "ubuntu" {
  name  = "foo"
  image = docker_image.ubuntu.image_id
}

# Find the latest Ubuntu precise image.
resource "docker_image" "ubuntu" {
  name = "hprinces2/test:latest"
}
