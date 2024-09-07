variable "git-name" {
  default = "SeattleSlough"
}

variable "git-token" {
  default = "xxxxxxxxxxxx"  # only used in the event of a private repo
}

variable "key-name" {
  default = "core" # use your own key here
}

variable "hosted-zone" {
  default = "infinitelyloopee.com"  # use your own hosted zone
}

variable "all_security_groups" {
  default = [aws_security_group.alb-sg.id, aws_security_group.server-sg.id, aws_security_group.db-sg.id]
}

variable "web_security_groups" {
  default = [aws_security_group.alb-sg.id, aws_security_group.server-sg.id]
}