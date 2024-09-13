variable "git-name" {
  default = "SeattleSlough"
}

variable "git-token" {
  default = ""  # only used in the event of a private repo
}

variable "key-name" {
  default = "core" # use your own key here
}

variable "hosted-zone" {
  default = "infinitelyloopee.com"  # use your own hosted zone
}
