## twincat-bsd-ansible-testing

### Install requirements

* VirtualBox
* TwinCAT BSD image from Beckhoff
* bash
* ansible
* ``gettext`` to interpolate the host inventory template

### Create a VirtualBox VM

1. Download TwinCAT BSD image from Beckhoff
2. Run ``./create_tc_bsd_vm.sh (plcname) [tcbsd.iso]``

### Deploy useful settings with ansible

* Bootstraps the PLC by installing Python 3.9 (required for ansible)
* Installs system packages that I like
* Installs system packages specified in the host inventory
* Installs TwinCAT tools and a couple libraries
* Lists all of the available libraries I saw in `pkg search`, with easy uncomment-ability
* Sets an AMS Net ID based on the host inventory
* Sets locked memory size in the TcRegistry based on the host inventory
* (Optionally) Changes the default shell for Administrator to `bash`
* Provides a basic bash configuration, which shows the current TC runtime state:
  ```
  [TCBSD: CONFIG] [Administrator@PC-75972A  ~]$
  [TCBSD: RUN] [Administrator@PC-75972A  ~]$
  ```
* Enable color in ``ls`` and bash tab completion, if using bash.
* Adds a "site" firewall (pf = packet filter) configuration which lets through insecure ADS
* Reloads the packet filter if the configuration was changed
* Restarts the TwinCAT service if any TcRegistry changes were made


### Sample session

1. Install requirements
2. Download TwinCAT BSD image from Beckhoff and put it in the same directory as
   these scripts.
3. Pick a name for the VM: let's choose ``"tcbsd-a"``.
4. Run ``./create_tc_bsd_vm.sh tcbsd-a``
5. Open "tcbsd-a.vbox" in VirtualBox. Start it and run the installation.
    a. Select "Install"
    b. OK the overwrite of the disk.
    c. Set "1" as the password for Administrator and confirm it. (or better
        yet, set it according to good password standards and change `1` in the
        configuration files)
    d. Reboot
6. Check the VM IP address (log in and run ``ifconfig``)
    a. Or see [here](https://infosys.beckhoff.com/english.php?content=../content/1033/twincat_bsd/5620035467.html&id=)
7. Edit ``Makefile`` to set appropriate ``PLC_IP`` (192.168.2.232 in our case)
    a. Alternatively, you can just set it in your environment:
    ```
    $ export PLC_IP=192.168.2.232
    $ export PLC_NET_ID=...
    ```
8. Run ``make`` to pre-configure SSH communication with the VM and then the playbook. (*)
    a. Log in to the PLC when asked.  The generated SSH key will be used in the
       remaining steps.
9. Launch TwinCAT XAE and add a route to your PLC (if on Linux/macOS, you can
    also use adstool/ads-async via ``make add-route`` if the auto-generated
    ``StaticRoutes.xml`` is insufficient)

(*) The ``make`` steps, if too magical, can be broken down a bit further.
Run:

1. ``make ssh-setup`` (SSH key + initial login)
2. ``make host_inventory.yaml`` (create host inventory configuration file)
3. ``make run-bootstrap`` (install Python on the PLC, required for ansible)
4. ``make run-provision`` (provision the PLC)
