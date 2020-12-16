## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "template_file" "tomcat_template" {
  template = "${file("./scripts/tomcat.sh")}"

  vars = {
    tomcat_port = var.tomcat_port
  }
}


data "oci_core_images" "OSImageLocal" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = var.OsImage
}

resource "oci_core_instance" "tomcat-server" {
  count               = var.numberOfNodes
  availability_domain = var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = "tomcat-${count.index}"
  shape               = var.InstanceShape

  create_vnic_details {
    subnet_id = oci_core_subnet.vcn01_subnet_app01.id
    display_name = "primaryvnic"
    assign_public_ip = false
    nsg_ids = [oci_core_network_security_group.SSHSecurityGroup.id, oci_core_network_security_group.APPSecurityGroup.id]
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.OSImageLocal.images[0], "id")
    boot_volume_size_in_gbs = "50"
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
    user_data           = base64encode(data.template_file.tomcat_template.rendered)
  }

}

data "oci_core_vnic_attachments" "tomcat-server_primaryvnic_attach" {
  count               = var.numberOfNodes
  availability_domain = var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  instance_id         = oci_core_instance.tomcat-server[count.index].id
}

data "oci_core_vnic" "tomcat-server_primaryvnic" {
  count   = var.numberOfNodes
  vnic_id = data.oci_core_vnic_attachments.tomcat-server_primaryvnic_attach[count.index].vnic_attachments.0.vnic_id
}
