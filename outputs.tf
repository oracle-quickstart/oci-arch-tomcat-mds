output "generated_ssh_private_key" {
  value = tls_private_key.public_private_key_pair.private_key_pem
}

output "todoapp_url" {
  value = "http://${oci_load_balancer.lb01.ip_addresses[0]}/todoapp/list"
}

output "bastion_public_ip" {
  value = oci_core_instance.bastion_instance.public_ip
}

output "tomcat-server_private_ips" {
  value = data.oci_core_vnic.tomcat-server_primaryvnic.*.private_ip_address
}

