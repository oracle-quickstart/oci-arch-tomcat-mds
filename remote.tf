data "template_file" "tomcat_template1" {
  template = "${file("./scripts/tomcat1_bootstrap.sh")}"

  vars = {
    db_name              = var.mysql_db_name
    db_user_name         = var.mysql_db_system_admin_username
    db_user_password     = var.mysql_db_system_admin_password
    db_server_ip_address = oci_mysql_mysql_db_system.mds01_mysql_db_system.ip_address
  }
}

data "template_file" "tomcat_template2" {
  template = "${file("./scripts/tomcat2_bootstrap.sh")}"
  
  vars = {
    db_name              = var.mysql_db_name
    db_user_name         = var.mysql_db_system_admin_username
    db_user_password     = var.mysql_db_system_admin_password
    db_server_ip_address = oci_mysql_mysql_db_system.mds01_mysql_db_system.ip_address
  }
}

data "template_file" "tomcat_context_xml" {
  template = "${file("./java/context.xml")}"
  
  vars = {
    db_user_name         = var.mysql_db_system_admin_username
    db_user_password     = var.mysql_db_system_admin_password
    db_server_ip_address = oci_mysql_mysql_db_system.mds01_mysql_db_system.ip_address
  }
}

resource "null_resource" "tomcat1_bootstrap" {
  depends_on = [oci_core_instance.tomcat-server1]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.tomcat-server1_primaryvnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.bastion_instance.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = data.template_file.tomcat_template1.rendered
    destination = "~/tomcat1_bootstrap.sh"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.tomcat-server1_primaryvnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.bastion_instance.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = "java/javaocidemo.war"
    destination = "~/javaocidemo.war"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.tomcat-server1_primaryvnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.bastion_instance.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = data.template_file.tomcat_context_xml.rendered
    destination = "~/context.xml"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.tomcat-server1_primaryvnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.bastion_instance.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem

    }
    inline = [
      "chmod +x ~/tomcat1_bootstrap.sh",
      "sudo ~/tomcat1_bootstrap.sh",
    ]
  }
}

resource "null_resource" "tomcat2_bootstrap" {
  depends_on = [oci_core_instance.tomcat-server2, null_resource.tomcat1_bootstrap]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.tomcat-server2_primaryvnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.bastion_instance.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = data.template_file.tomcat_template2.rendered
    destination = "~/tomcat2_bootstrap.sh"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.tomcat-server2_primaryvnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.bastion_instance.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = "java/javaocidemo.war"
    destination = "~/javaocidemo.war"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.tomcat-server2_primaryvnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.bastion_instance.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = data.template_file.tomcat_context_xml.rendered
    destination = "~/context.xml"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.tomcat-server2_primaryvnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.bastion_instance.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem

    }
    inline = [
      "chmod +x ~/tomcat2_bootstrap.sh",
      "sudo ~/tomcat2_bootstrap.sh",
    ]
  }
}