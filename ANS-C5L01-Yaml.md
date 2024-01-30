# Labs - Working with YAML
## Lab Contents
- Introducing YAML
- Reviewing a Linux Netplan YAML File

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
!IMAGE[x8i49ojb.jpg](instructions247478/x8i49ojb.jpg)

==========================
# Lab 1 - Introducing YAML
## Requirements
Before you begin you need to understand:
- Data serialization using JSON
## Scenario
In this lab, you will learn how to use YAML to store data properties in the same way JSON is used
## Objectives
At the end of this lab you will be able to:
- Understand how data is represented using YAML
- Create expressive data structures using YAML
## Lab
### Convert from JSON to YAML
1. The YAML content below was created by converting the JSON shown below.  Blank lines were added to the YAML text so that it would roughly match the JSON text but are not required.

&nbsp;|JSON|YAML
--|----|----
01|{|---
02|&nbsp;&nbsp;"version":&nbsp;"13.1",|version:&nbsp;'13.1'
03|&nbsp;&nbsp;"monitor":&nbsp;{|monitor:
04|&nbsp;&nbsp;&nbsp;&nbsp;"name":&nbsp;"test.mon",|&nbsp;&nbsp;name:&nbsp;test.mon
05|&nbsp;&nbsp;&nbsp;&nbsp;"request":&nbsp;"/ping",|&nbsp;&nbsp;request:&nbsp;"/ping"
06|&nbsp;&nbsp;&nbsp;&nbsp;"response":&nbsp;"pong"|&nbsp;&nbsp;response:&nbsp;pong
07|&nbsp;&nbsp;},|
08|&nbsp;&nbsp;"pool":&nbsp;{|pool:
09|&nbsp;&nbsp;&nbsp;&nbsp;"name":&nbsp;"test.pool",|&nbsp;&nbsp;name:&nbsp;test.pool
10|&nbsp;&nbsp;&nbsp;&nbsp;"monitor":&nbsp;"test.mon",|&nbsp;&nbsp;monitor:&nbsp;test.mon
11|&nbsp;&nbsp;&nbsp;&nbsp;"members":&nbsp;[|&nbsp;&nbsp;members:
12|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{|
13|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"address":&nbsp;"10.10.1.1",|&nbsp;&nbsp;-&nbsp;address:&nbsp;10.10.1.1
14|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"port":&nbsp;80|&nbsp;&nbsp;&nbsp;&nbsp;port:&nbsp;80
15|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;},|
16|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{|
17|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"address":&nbsp;"10.10.1.2",|&nbsp;&nbsp;-&nbsp;address:&nbsp;10.10.1.2
18|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"port":&nbsp;80|&nbsp;&nbsp;&nbsp;&nbsp;port:&nbsp;80
19|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}|
20|&nbsp;&nbsp;&nbsp;&nbsp;]|
21|&nbsp;&nbsp;},|
22|&nbsp;&nbsp;"virtual":&nbsp;{|virtual:
23|&nbsp;&nbsp;&nbsp;&nbsp;"name":&nbsp;"test.vs",|&nbsp;&nbsp;name:&nbsp;test.vs
24|&nbsp;&nbsp;&nbsp;&nbsp;"address":&nbsp;"10.10.1.33",|&nbsp;&nbsp;address:&nbsp;10.10.1.33
25|&nbsp;&nbsp;&nbsp;&nbsp;"port":&nbsp;443,|&nbsp;&nbsp;port:&nbsp;443
26|&nbsp;&nbsp;&nbsp;&nbsp;"profiles":&nbsp;[|&nbsp;&nbsp;profiles:
27|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"tcp",|&nbsp;&nbsp;-&nbsp;tcp
28|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"http",|&nbsp;&nbsp;-&nbsp;http
29|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"clientssl"|&nbsp;&nbsp;-&nbsp;clientssl
30|&nbsp;&nbsp;&nbsp;&nbsp;],|
31|&nbsp;&nbsp;&nbsp;&nbsp;"automap":&nbsp;true,|&nbsp;&nbsp;automap:&nbsp;yes
32|&nbsp;&nbsp;&nbsp;&nbsp;"pool":&nbsp;"test.pool"|&nbsp;&nbsp;pool:&nbsp;test.pool
33|&nbsp;&nbsp;}|
34|}|

### Understand the conversion from JSON to YAML
2. Answer the following questions:

Q: Why is the YAML version so much shorter? __________________________________

Q: How many lines shorter is the YAML version? __________________________________

>[+NOTE] Note: Neither the keys not the values are quoted in YAML, but there are two exceptions

Q: Why is the YAML version so much shorter? __________________________________

>[+Hint] Remember: JSON only indents its data structures for readability, but YAML requires that the data be properly indented (just like Python)

Q: Are JSON and YAML both indented to the same level for each key? __________________________________

>[+NOTE] Note: Some of the keys start with a dash, but most do not. 

Q: Why is that? __________________________________

Q: Which is easier for you to read? __________________________________

Q: Which is more intuitive? __________________________________

- Open the jumpX browser to https://www.json2yaml.com and type in the above JSON into the left column and compare the results with the YAML above 

>[+Hint] Hint: If you don't want to type this much text, copy the text from ~/Documents/Automating_BIG-IP/v1.7/JSON/bigip-config.json and paste it into the left column

>[+Hint] Hint: Keep this URL handy. It will help you understand the subtleties of YAML by viewing the equivalent JSON

Q: Are they the same? __________________________________

    - Clear the JSON column and paste the above YAML into the right column.  Compare the results with the JSON above.

Q: Are they the same? __________________________________

    - In the YAML column, change automap: true to automap: yes (this is valid YAML syntax)

Q: What happens to the JSON? __________________________________

Q: Why could this be a problem? __________________________________

Q: How would you work around this?__________________________________

============================
# Answers to Lab 1 Questions

Q: Why is the YAML version so much shorter? **No extra lines for closing curly braces or square brackets**

Q: How many lines shorter is the YAML version? **10**

Q: Why is the YAML version so much shorter? **Keep '13.1' a string rather than a number and '/ping' starts with a special character**

Q: Are JSON and YAML both indented to the same level for each key? **Yes, except JSON starts out indented after the initial curly brace, there are two extra spaces**

Q: Why is that? **Arrays of objects start with a dash**

Q: Which is easier for you to read? **YAML (for the author, ymmv)**

Q: Which is more intuitive? **JSON (for the author, ymmv)**

Q: Are they the same? **Yes, except for the extra blank lines**

Q: Are they the same? **Yes**

Q: What happens to the JSON? **It stays true**

Q: Why could this be a problem? **If you really needed the value "yes" in JSON**

Q: How would you work around this? **Wrap yes and no in single or double quotes**

=============================================
# Lab 2 - Reviewing a Linux Netplan YAML File
## Requirements
Before you begin you need to understand:
- How YAML syntax works
- How YAML can be used to provide configuration information
## Objectives
At the end of this lab you will be able to:
- Configure network setting for Linux systems using Netplan
- Understand production uses for YAML and JSON configuration files
## Lab
### Examine the Netplan YAML File
1. Take a minute to examine the following Netplan YAML file. This file is used by Ubuntu for network configuration and is located at /etc/netplan/01-netcfg.yaml

>[+Hint] Hint: To understand exactly how YAML relates to JSON representation, go to https://www.json2yaml.com, paste in the YAML configuration and compare the two side-by-side

&nbsp;|YAML
--|----
01|network:
02| &nbsp;version:&nbsp;2
03| &nbsp;renderer:&nbsp;networkd
04| &nbsp;ethernets:
05| &nbsp; &nbsp;ens160:
06| &nbsp; &nbsp; &nbsp;dhcp4:&nbsp;false
07| &nbsp; &nbsp; &nbsp;addresses:
08| &nbsp; &nbsp; &nbsp;-&nbsp;10.10.1.29/16
09| &nbsp; &nbsp; &nbsp;gateway4:&nbsp;10.10.17.33
10| &nbsp; &nbsp; &nbsp;nameservers:
11| &nbsp; &nbsp; &nbsp; &nbsp;addresses:
12| &nbsp; &nbsp; &nbsp; &nbsp;-&nbsp;10.10.1.2
13| &nbsp; &nbsp; &nbsp; &nbsp;search:
14| &nbsp; &nbsp; &nbsp; &nbsp;-&nbsp;f5trn.com
15| &nbsp; &nbsp;ens192:
16| &nbsp; &nbsp; &nbsp;dhcp4:&nbsp;false
17| &nbsp; &nbsp; &nbsp;addresses:
18| &nbsp; &nbsp; &nbsp;-&nbsp;192.168.1.29/16

>[+Alert] Warning: If you inject this text directly into your browser, it will not format correctly.  First open `nano` in a Terminal window and inject the text into nano.  Then copy the text from nano and paste it into the YAML pane of the browser window at the above URL.

+++
network:
  version: 2
  renderer: networkd
  ethernets:
    ens160:
      dhcp4: false
      addresses:
      - 10.10.1.29/16
      gateway4: 10.10.17.33
      nameservers:
        addresses:
        - 10.10.1.2
        search:
        - f5trn.com
    ens192:
      dhcp4: false
      addresses:
      - 192.168.1.29/16
+++

### Understand how YAML serialized data
2. Answer the following questions:

Q: Which objects have values that are arrays? __________________________________

Q: Do any of these arrays contain more than one item? __________________________________

Q: Why do you think arrays are used for these objects? __________________________________

3. Convert the above YAML into JSON using the converter at https://www.json2yaml.com 

Q: How many more lines is the JSON version? __________________________________

Q: Do both the YAML and JSON versions represent the exact same data?__________________________________

Q: Which data types are represented above? __________________________________

============================
# Answers to Lab 2 Questions

Q: Which objects have values of arrays? **addresses and search**

Q: Do any of these arrays contain more than one item? **No**

Q: Why do you think arrays are used for these objects? **This can specify multiple host and DNS addresses and multiple DNS search domains**

Q: How many more lines is the JSON version? **10**

Q: Do both the YAML and JSON versions represent the exact same data? **Yes**

Q: Which data types are represented above? **Arrays, Objects, Strings, Numbers and Booleans**
