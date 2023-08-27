terraform {
  cloud {
    organization = "dannycyberwalker"

    workspaces {
      name = "hexlet-workspace"
    }
  }
}