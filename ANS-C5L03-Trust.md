# Labs - Building Trust
## Lab Contents
- Creating a Trust Relationship
- Creating an Alternate Trust Relationship

## Lab Credentials and IP Address List
External IP  | Internal IP   | Management IP | Hostname | Credentials / Comments
-------------|---------------|---------------|----------|-----------------------------------
10.10.0.0/16 | 172.16.0.0/16 | 192.168.0.0   |          | *Lab Network*
10.10.0.33   |               | 192.168.0.33  |          | *Default Route*
10.10.1.1    |               |               | ubuntu1a | **student / student**
10.10.1.2    |               |               | ubuntu1b | **student / student**
10.10.1.29   |               | 192.168.0.29  | jump1    | **student / student**
10.10.1.31   | 172.16.1.31   | 192.168.1.31  | bigip1a  | **admin\|root / f5trn001**
10.10.1.32   | 172.16.1.32   | 192.168.1.32  | bigip1b  | **admin\|root / f5trn001**
10.10.1.33   | 172.16.1.33   |               |          | *HA Self-IP*
10.10.1.101  |               |               | app1     | *Virtual Server*
10.10.1.101  |               |               | wiki1    | *Virtual Server*
10.10.1.101  |               |               | www1     | *Virtual Server*

## Lab Network Topology
!IMAGE[0u9e19nj.jpg](instructions247483/0u9e19nj.jpg)

=======================================
# Lab 3 - Creating a Trust Relationship
## Requirements
Before you begin you need:
- A basic understanding of the Ansible client-less architecture
## Scenario
In this lab, you will learn how to build to Ansible trust relationships with a Linux server
## Objectives
At the end of this lab you will be able to:
- Invoke Ansible to perform a basic task on a remote host
## Lab
### Test basic connectivity to a remote host
Ansible is all about playbooks, but before you dive into them, look at the Ansible command line to better understand the Ansible environment
1. The commands in the following steps must be entered in your home directory.  Type the following to change directory to your home directory and then confirm:

```BASH-nocopy
jump$ cd
jump$ pwd
/home/student
```
2. You must create an Ansible inventory file, which is a list of the machines you plan to configure or query. This file is typically named hosts, but should not be confused with the computer’s hosts file (/etc/hosts) which maps hostnames to IP addresses and is used when DNS is not available. So far, you only have one device to be work with, ubuntu1a:

  &nbsp; | Filename: ~/hosts
  -------|------------------
  01     | ubuntu1a

3. In the following step, Ansible is trying ping ubuntu1a to determine if it can configure it. Ansible attempts to ssh to ubuntu1a, but ssh is unable to connect because it is uncertain about the authenticity of the remote host. If you type yes, the connection will proceed. In this case, we want the command to complete without any further user intervention. Type no when you get to the prompt. Type the following ssh command to confirm the first part of the Ansible message is from ssh

>[+Note] Synopsis: ping is a trivial test module, that always returns pong on successful contact. It may not make sense in most playbooks, but it is useful to verify the ability to log in and confirm that Python is properly configured.  

>[+Note] Note: This is not ICMP ping.

```BASH-nocopy
jump$ ansible ubuntu1a --inventory-file=hosts --module-name=ping 
The authenticity of host 'ubuntu1a (10.10.X.1)' can't be established.
ECDSA key fingerprint is SHA256:dNFbvKxxCkb0g+3OGBxpYvgyAq21SGtf6/QsbhFqAqw.
Are you sure you want to continue connecting (yes/no)? no
ubuntu1a | UNREACHABLE! => {
    "changed": false, 
    "msg": "Failed to connect to the host via ssh: Host key verification fa... 
    "unreachable": true 
}
jump$ ssh ubuntu1a
The authenticity of host 'ubuntu1a (10.10.X.1)' can't be established.
ECDSA key fingerprint is SHA256:dNFbvKxxCkb0g+3OGBxpYvgyAq21SGtf6/QsbhFqAqw.
Are you sure you want to continue connecting (yes/no)? no
jump$
```

Q: What unattended use cases do you have? ___________________________________________

4. If you instinctively typed yes at either of the ssh prompts above, ubuntu1a is now in the known hosts file and you will need to remove it as shown here: 

>[+Note] Note:  Normally you would only delete the ubuntu1a entry within that file, but currently it is the only entry

`rm ~/.ssh/known_hosts`

5. To prevent the ssh warning, create an Ansible configuration file as shown here:

  &nbsp;|Filename: ~/.ansible.cfg
  ------|--------------
      01|[defaults]
      02|host_key_checking=false

>[+Note] Note: Ansible allows you to override the default behavior of ansible commands using the following (in order of highest precedence):
ANSIBLE_CONFIG	Environment variable overrides individual user sessions
ansible.cfg	Overrides command launched from a specific directory
~/.ansible.cfg	Overrides commands launched by a specific user
/etc/ansible/ansible.cfg	Overrides any command launched on the host

>[+Note] Note: Use a dot as the first character of the filename so you will be able to perform all the labs of this chapter. If you leave off the dot, the configuration options will only apply to ansible command run from this directory and you will need a configuration file for every other directory you use 

>[+Note] Note: Starting a filename with a dot makes the file invisible to the base ls command. To see file names starting with a dot, use the command with a flag: ls -a

6.	Try to run the ansible ping command again

>[+Note] Note: Because of the above configuration, Ansible (using ssh) permanently added ubuntu1a to the list of known hosts. However, permission is still denied. Try ssh’ing as shown below and you will determine that ubuntu1a requires a password

```BASH-nocopy
jump1$ ansible ubuntu1a --inventory-file=hosts --module-name=ping   
ubuntu1a | UNREACHABLE! => {
    "changed": false,  
    "msg": "Failed to connect to the host via ssh: Warning: Permanently added 'ubuntu1a,10.10.X.1' (ECDSA) to the list of known hosts.\r\nPermission denied (publickey,password).\r\n",  
    "unreachable": true 
}
jump1$ ssh ubuntu1a
student@ubuntu1a's password: <CTRL-C>
jump1$
```

7.	Edit the hosts file to include the password for user student on ubuntu1a

>[+Note] Note: Spaces matter in the hosts file. Do not put spaces around the equal sign here
Filename: ~/hosts
01	ubuntu1a ansible_ssh_pass=student

8.	Try the ansible command for a third time and note that it succeeds, but with a warning:

>[+Note] Note: Starting with Ansible 2.9, any system using Python 2 will generate a deprecation warning. You can get rid of the warning by telling Ansible to use Python 3 in the hosts file

>[+Alert] Warning: If you are using Ubuntu 18.04, you will receive the following warning:
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu1a should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform python for this host.
See https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.

9.	If you did not receive a deprecation warning, you should have seen the following output:
```BASH-nocopy
ubuntu1a | SUCCESS => {
    "ansible_facts": { 
        "discovered_interpreter_python": "/usr/bin/python3" 
    }, 
    "changed": false, 
    "ping": "pong" 
}
```

10.	Edit the .ansible.cfg file to include a directive to tell Ansible to use Python 3. Do not put spaces around the equal sign here:

  &nbsp;| Filename: ~/.ansible.cfg
  ------|-------------------------
    01| [defaults]
    02| host_key_checking=false
    03| interpreter_python=python3

11. Try the ansible command again and note that it succeeds this time without a warning or additional text. The command returns a success status and two additional lines
```BASH-nocopy
jump$ ansible ubuntu1a --inventory-file=hosts --module-name=ping
ubuntu1a | SUCCESS => {
    "changed": false,  
    "ping": "pong" 
}
jump$ 
```

12.	Answer the following questions:

 	Q: Did the command make any changes on ubuntu1a? ___________________________________

 	Q: What was the ping response? ___________________________________

 	Q: What is the first argument of the Ansible command above? ___________________________________

 	Q: What is the second argument (flag and value)? ___________________________________

 	Q: What is the third argument? ___________________________________

## Make the Ansible command more convenient to use

13.	You can make the command a little shorter by avoiding the second argument if you add that information to the Ansible configuration file. Edit that information into the Ansible configuration you created earlier:

>[+Note] Note: Spaces around the equal sign are acceptable in this file

&nbsp; | Filename: ~/.ansible.cfg
-------|--------------------------
    01 | [defaults]
    02 | host_key_checking=false
    03 | interpreter_python=python3
    04 | inventory=hosts

14. Try the command now, without the inventory-file flag

```BASH-nocopy
jump$ ansible ubuntu1a --module-name=ping
ubuntu1a | SUCCESS => {
    "changed": false,  
    "ping": "pong" 
}
jump$
```

15. Finally, if you want this command to apply to all of the hosts in the inventory, replace the host name with the word all

>[+Note] Note: In your case there is only one host in that file, so the results will be the same

```BASH-nocopy
jump$ ansible all --module-name=ping
ubuntu1a | SUCCESS => {
    "changed": false, 
    "ping": "pong" 
}
jump$
```

Q: Why would you use the Ansible ping command? ___________________________________________

16. Edit the hosts file to include the username for user student on ubuntu1a

>[+Note] Note: Spaces matter in the hosts file.  Do not put spaces around the equal sign here

&nbsp; | Filename: ~/hosts
-------|------------------
    01 | ubuntu1a ansible_ssh_user=student ansible_ssh_pass=student

17.	Run the Ansible ping command again

Q: Did it work this time? ___________________________________________

Q: It would seem the latest change to the hosts file was redundant.  Why might the new change be useful? ___________________________________________

============================
# Answers to Lab 3 Questions

Q: What unattended use cases do you have? **This is an open-ended question to make you think about your environment**

Q: Did the command make any changes on ubuntu1a? **No**

Q: What was the ping response? **pong**

Q: What is the first argument of the ansible command above? **ubuntu1a**

Q: What is the second argument (flag and value)? **--inventory-file=hosts**

Q: What is the third argument? **--module-name=ping**

Q: Why would you use the Ansible ping command? **Test if the server is up or if the ansible command is working**

Q: Did it work this time? **Yes**

Q: Why might the new change be useful? **It allows the Ansible controller to use a different username than the username on the remote target**

==================================================

# Lab 4 - Creating an Alternate Trust Relationship

## Requirements
Before you begin you need to understand:
- How to use a simple Ansible command with the same local and remote username
## Objectives
At the end of this lab you will be able to:
- How to use a simple Ansible command with different local and remote usernames

### Ping a remote host with an alternate username
1. Edit the hosts file to include both the new username and new password for the remote user

&nbsp; | Filename: ~/hosts
-------|------------------
    01 | ubuntu1a ansible_ssh_user=ansible ansible_ssh_pass=ansible

2.	Rerun the Ansible ping command

```BASH-nocopy
jump$ ansible all --module-name=ping
ubuntu1a | SUCCESS => {
    "changed": false, 
    "ping": "pong" 
}
jump$
```

Q: Did it run successfully? ___________________________________________

Note: In the ansible command above, you changed the target from ubuntu1a to all, which runs the command on every computer in the hosts file (but there is only one, so far)

### Run a different command

3. Until now, you have only used the ping module in the ansible command.   Try a new one here:

```BASH-nocopy
jump$ ansible all --module-name=command --args=date
ubuntu1a | SUCCESS | rc=0 >>
Sun Mar 18 21:50:40 EDT 2018
jump$
```

4. Answer the following questions:

 	Q: What new module did you run in this command? ___________________________________________

 	Q: What is the args flag used for? ___________________________________________

### Run a command that requires superuser privileges

5. Use ansible to run the apt update command as shown here:

```BASH-nocopy
jump$ ansible all --module-name=apt --args="update-cache=true"
ubuntu1a | FAILED! => {
    "changed": false,  
    "msg": "Failed to lock apt for exclusive operation" 
}
jump$ 
```

Q: What Ubuntu command does the run? ___________________________________________

Q: What do the args tell the module? ___________________________________________

Q: Why did the command fail? ___________________________________________

6. The apt update command needs to run as superuser (root). Change the username and password in the hosts file to root as shown here:

&nbsp; | Filename: ~/hosts
-------|------------------
    01 | ubuntu1a ansible_ssh_user=root ansible_ssh_pass=root

7. Rerun the Ansible command

```BASH-nocopy
jump$ ansible all --module-name=apt --args="update-cache=true"
ubuntu1a | UNREACHABLE! => {
    "changed": false,  
    "msg": "Authentication failure.",  
    "unreachable": true 
}
jump$
```

8.	Answer the following questions:

Q: Why did authorization fail? ___________________________________________

9. Test it for yourself by ssh’ing to ubuntu1a as root

``` BASH-nocopy
jump$ ssh root@ubuntu1a
root@ubuntu1a's password: root
Permission denied...Authentication failed.
jump$ 
```

Q: Why did this command fail? ___________________________________________

>[+Hint] Hint: the ssh results give you the answer

10. You tried using Ansible to log in as user ansible and discovered you did not have sufficient privileges. Next you tried logging in as root only to learn that didn’t work either because Ubuntu will not allow ssh to the superuser (root) account.Try using Ansible to log in with a working, non-privileged account and escalate privileges with sudo. Edit the hosts file as shown

>[+Hint] Remember: With sudo, you use the user’s password, not the root password 
  
>[+Hint] Note: This line has gotten very long and has wrapped around twice as shown below, but this is all one line in the file. If you insert it into the file as three lines, the command will fail

&nbsp; | Filename: ~/hosts
-------|------------------
    01 | ubuntu1a ansible_ssh_user=ansible ansible_ssh_pass=ansible
    .. | ansible_become=true ansible_become_method=sudo
    .. | ansible_sudo_pass=ansible

11. In addition to the hostname, there are five directives on this line. What do each of them do?
Describe the following directives:

ansible_ssh_user=ansible ___________________________________________

ansible_ssh_pass=ansible ___________________________________________

ansible_become=true ___________________________________________

ansible_become_method=sudo ___________________________________________

ansible_sudo_pass=ansible ___________________________________________

12. Rerun the Ansible command to perform an apt update

``` BASH-nocopy
jump$ ansible all --module-name=apt --args="update-cache=true"
ubuntu1a | SUCCESS => {
    "cache_update_time": 1521425072,  
    "cache_updated": true,  
    "changed": true 
}
jump$
```

Q: Did it work this time? ___________________________________________ 

Q: What password did you provide to enable privilege escalation? ___________________________________________

### Use su instead of sudo
13. On some machines, sudo may not be available, or the user account may not have sudo access.  In this case, you will need to use the su method to escalate privilege mode, ie, become superuser.  Test the following example:

&nbsp; | Filename: ~/hosts
-------|------------------
    01 | ubuntu1a ansible_ssh_user=ansible ansible_ssh_pass=ansible
    .. | ansible_become=true ansible_become_method=su
    .. | ansible_su_pass=root

14. Two of the directives changed this time.  What are they and what do they do?

First directive: ___________________________________________ 

Second directive: ___________________________________________ 

>[+Note] Note: If you don’t change the second directive, the ansible command will fail with a Timeout waiting for privilege escalation prompt message

15. Rerun the Ansible command

``` BASH-nocopy
jump$ ansible ubuntu1a --module-name=apt --args="update-cache=true"
...
jump$
```

Q: Did it work this time? ___________________________________________

Q: Was the cache updated on the second try? Why? ___________________________________________

Q: What password did you provide to enable privilege escalation? ___________________________________________

============================
# Answers to Lab 4 Questions

Q: Did it run successfully? **Yes**

Q: What new module did you run in this command? **command**

Q: What is the args flag used for? **To tell Ansible which command to run**

Q: What Ubuntu command does the run? **apt (the Ubuntu utility for installing and update software packages)**

Q: What do the args tell the module? **Run apt update**

Q: Why did the command fail? **Apt needs to run with superuser privileges**

Q: Why did authorization fail? **By default, for security reasons, users cannot log into Ubuntu using the root username**

Q: Why did this command fail? **Same reason as previous command**

ansible_ssh_user=ansible	**Ssh login username for remote device**

ansible_ssh_pass=ansible	**Ssh login password for remote device**

ansible_become=true	**After login, become superuser**

ansible_become_method=sudo	**After login, become superuser using the sudo command**

ansible_sudo_pass=ansible	**Password to use at the sudo prompt (i.e., the user's login password)**

Q: Did it work this time? **Yes**

Q: What password did you provide to enable privilege escalation? **ansible ... which is the user's password**

First directive:	**ansible_become_method=su**

Second directive:	**ansible_su_pass=root**

Q: Did it work this time? **Yes**

Q: Was the cache updated on the second try? Why? **Probably no, because it had just been updated and there was no new updates available in the minute or so between running the commands**

Q: What password did you provide to enable privilege escalation? **root ... which is the very insecure root password**
