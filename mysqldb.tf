resource "oci_mysql_mysql_db_system" "mds01_mysql_db_system" {
    #Required
    admin_password = var.mysql_db_system_admin_password
    admin_username = var.mysql_db_system_admin_username
    availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
    compartment_id = var.compartment_ocid
    configuration_id = data.oci_mysql_mysql_configurations.mds_mysql_configurations.configurations[0].id
    shape_name = data.oci_mysql_mysql_configurations.mds_mysql_configurations.configurations[0].shape_name
    subnet_id = oci_core_subnet.vcn01_subnet_db01.id

    # #Optional
    # backup_policy {

    #     #Optional
    #     is_enabled = var.mysql_db_system_backup_policy_is_enabled
    #     retention_in_days = var.mysql_db_system_backup_policy_retention_in_days
    #     window_start_time = var.mysql_db_system_backup_policy_window_start_time
    # }
    data_storage_size_in_gb = var.mysql_db_system_data_storage_size_in_gb
    # defined_tags = {"foo-namespace.bar-key"= "value"}
    # description = var.mysql_db_system_description
    display_name = var.mysql_db_system_display_name
    # fault_domain = var.mysql_db_system_fault_domain
    # freeform_tags = {"bar-key"= "value"}
    hostname_label = var.mysql_db_system_hostname_label
    # ip_address = var.mysql_db_system_ip_address
    # maintenance {
    #     #Required
    #     window_start_time = var.mysql_db_system_maintenance_window_start_time
    # }
    # mysql_version = var.mysql_db_system_mysql_version
    # port = var.mysql_db_system_port
    # port_x = var.mysql_db_system_port_x
    # source {
    #     #Required
    #     source_type = var.mysql_db_system_source_source_type

    #     #Optional
    #     backup_id = oci_mysql_mysql_backup.test_backup.id
    # }
}