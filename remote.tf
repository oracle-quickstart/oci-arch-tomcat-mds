## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "template_file" "tomcat_service_template" {
  count    = var.numberOfNodes
  template = file("./scripts/tomcat.service")

  vars = {
    tomcat_version = var.tomcat_version
  }
}

data "template_file" "tomcat_bootstrap_template" {
  count    = var.numberOfNodes
  template = file("./scripts/tomcat_bootstrap.sh")

  vars = {
    db_name              = var.mysql_db_name
    db_user_name         = var.mysql_db_system_admin_username
    db_user_password     = var.mysql_db_system_admin_password
    db_server_ip_address = oci_mysql_mysql_db_system.mds01_mysql_db_system.ip_address
    tomcat_host          = "tomcat-server-${count.index}"
    tomcat_version       = var.tomcat_version
    tomcat_major_release = split(".", var.tomcat_version)[0]
  }
}

data "template_file" "tomcat_context_xml" {
  template = file("./java/context.xml")

  vars = {
    db_user_name         = var.mysql_db_system_admin_username
    db_user_password     = var.mysql_db_system_admin_password
    db_server_ip_address = oci_mysql_mysql_db_system.mds01_mysql_db_system.ip_address
  }
}

resource "null_resource" "tomcat_bootstrap" {
  count      = var.numberOfNodes
  depends_on = [oci_core_instance.tomcat-server]

  provisioner "file" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.tomcat-server_primaryvnic[count.index].private_ip_address
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip
      bastion_port        = "22"
      bastion_user        = var.use_bastion_service ? oci_bastion_session.ssh_via_bastion_service[count.index].id : "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = data.template_file.tomcat_bootstrap_template[count.index].rendered
    destination = "/home/opc/tomcat_bootstrap.sh"
  }

  provisioner "file" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.tomcat-server_primaryvnic[count.index].private_ip_address
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip
      bastion_port        = "22"
      bastion_user        = var.use_bastion_service ? oci_bastion_session.ssh_via_bastion_service[count.index].id : "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = data.template_file.tomcat_service_template[count.index].rendered
    destination = "/home/opc/tomcat.service"
  }

  provisioner "file" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.tomcat-server_primaryvnic[count.index].private_ip_address
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip
      bastion_port        = "22"
      bastion_user        = var.use_bastion_service ? oci_bastion_session.ssh_via_bastion_service[count.index].id : "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = data.template_file.tomcat_context_xml.rendered
    destination = "~/context.xml"
  }
  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.tomcat-server_primaryvnic[count.index].private_ip_address
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip
      bastion_port        = "22"
      bastion_user        = var.use_bastion_service ? oci_bastion_session.ssh_via_bastion_service[count.index].id : "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem

    }
    inline = [
      "chmod +x ~/tomcat_bootstrap.sh",
      "sudo ~/tomcat_bootstrap.sh"

    ]
  }
}

