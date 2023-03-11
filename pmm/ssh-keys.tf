resource "aws_key_pair" "michael-coburn-terraform-user" {
  key_name   = "michael-coburn-terraform-user"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2R7C3bpt5n1rTI2dH+pZ4SW8lfLOlxutm4seSDDUdU pmm-demo-user"
}
