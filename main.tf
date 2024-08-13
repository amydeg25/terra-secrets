provider "aws" {
  region = "eu-central-1"
}

provider "vault" {
  address          = "http://18.192.213.244:8200"
  skip_child_token = true # Auth will fail without this!!

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = "69732f5a-245c-a414-0c07-29ff2e5302a5"
      secret_id = "4d3ccf27-d947-354d-04fd-50cfb8b38716"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test-secret"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0e872aee57663ae2d"
  instance_type = "t2.micro"

  tags = {
    Name   = "test"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}
