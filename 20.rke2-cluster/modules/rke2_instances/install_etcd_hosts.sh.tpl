%{ for idx, host in hosts ~}
sudo sh -c 'echo "${host.ip} ${host.name}" >> /etc/hosts'
%{ endfor ~}
