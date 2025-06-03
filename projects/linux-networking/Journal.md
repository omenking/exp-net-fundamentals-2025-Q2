## Linux Firewall Rules

### Goal

We want to see how easy or difficult it is to manage GCP firewall rules and linux fire wall rules


### Considerations

We are launch Debian latest version of GCP, We aren't sure what is installed by default.

## Investigation

- IPTables was already installed
- Python3 was already installed

We were able to edit the iptables through commands, direct editing iptables files wasn't possible and even if we could it's not recommended.

We could have use ufw but we wanted to get experience with iptables since on some machines we might not be allowed to install packages.

## Outcomes

We able to open port 7000,8000 in GCP firewall rules

We were able to use curl with a 2 seecond timeout and reach the website with port 8000

We were able to block port 8000 on iptables

We were able to redirect from 7000 externally to 8000 using iptables

We could not combine port 8000 block and redirect 7000 to 8000 but we suspect its possible.

It seems that iptables is easy when utilizing a AI Coding Assistant eg. ChatGPT so there is no need for ufw unless we didn't have access to an LLM and we wanted to simply use man to quickly learn how to chnage rules or have an easy to remember how to change rules.