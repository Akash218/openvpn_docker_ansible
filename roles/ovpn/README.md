OVPN
=========

   keep all dependency files in a folder,
please mention the exact location of"client.ovpn file,
pkcs12_file,username and password file" in group_vars(openvpn) file.

Role Variables
--------------

please make sure, you are giving the correct information in inventory/hosts file.

Dependencies
------------

Ansible

Example Playbook
----------------

    - hosts: servers
      roles:
         - rolename

Author Information
------------------

   name=Akash
   email=akash@mydbops.com
