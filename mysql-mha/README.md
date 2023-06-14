# mysql-mha
마스터 장애 복구 및 빠른 마스터 전환을 자동화하기 위한 마스터 고가용성 관리자 및 MySQL용 도구(MHA)


### MySQL 체크
#### MySQL 명령어 PATH 등록 및 link 설정
```
sudo sh -c 'echo "export PATH=\"/usr/local/mysql/bin:\$PATH\"" >> /etc/profile'
```
```
sudo ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
```
```
sudo ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe
```
```
sudo ln -s /usr/local/mysql/bin/mysqladmin /usr/bin/mysqladmin
```
```
sudo ln -s /usr/local/mysql/bin/mysqlbinlog /usr/bin/mysqlbinlog
```
#### MySQL 리플레케이션 계정 생성
```
use mysql;
```
```
grant all privileges on *.* to 'mhauser'@'192.168.56.0/24' identified by 'mhapassword';
```

## MySQL MHA 설치
#### 1. mhauser 계정 생성 및 sudo 설정
```
useradd -m -c "MHA user" -d /home/mhauser -s /bin/bash mhauser
```
```
echo "mhauser:mhapassword" | chpasswd
```
```
echo "mhauser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
```
```
echo 'export PS1="\[\e[31m\]\u\[\e[m\]\[\e[37m\]@\[\e[m\]\[\e[33m\]\h\[\e[m\]:\[\033[01;36m\]\W\[\e[m\]$ "' >> ~/.bashrc
```
```
sudo usermod -aG mysql mhauser
```

#### 2. mhauser 계정의 ssh key 생성 및 설정
```
su - mhauser
```
```
ssh-keygen -t rsa
```
```
ssh-copy-id mhauser@192.168.56.101
```
```
scp ~/.ssh/id_rsa mhauser@192.168.56.101:~/.ssh/id_rsa
```

#### 3. mha 디렉토리 생성 및 소유권 변경
```
mkdir -p ~/mha/{conf,scripts,logs}
```
```
sudo chown -R mhauser.mysql ~/mha
```


#### 4. mha 패키지 설치

#### 5. mha 스크립트 작성
```
vim /etc/masterha_default.cnf
```
```
vim /home/mhauser/mha/conf/mha.cnf
```
```
vim /home/mhauser/mha/scripts/master_ip_failover
```
```
chmod +x /home/mhauser/mha/scripts/master_ip_failover
```
```
vim /home/mhauser/mha/scripts/master_ip_online_change
```
```
chmod +x /home/mhauser/mha/scripts/master_ip_online_change
```

#### 6. mha vip 설정
```
ifconfig enp0s8:0 192.168.56.100 netmask 255.255.255.0 broadcast 192.168.56.255 up
```

#### 7. mha 명령어 alias 설정
```
vim ~/.bashrc 
```
```
alias sshcheck='/usr/bin/masterha_check_ssh --conf=/home/mhauser/mha/conf/mha.cnf'
alias replcheck='/usr/bin/masterha_check_repl --conf=/home/mhauser/mha/conf/mha.cnf'
alias mha_start='/usr/bin/masterha_manager --conf=/home/mhauser/mha/conf/mha.cnf &'
alias mha_stop='/usr/bin/masterha_stop --conf=/home/mhauser/mha/conf/mha.cnf'
alias mha_status='/usr/bin/masterha_check_status --conf=/home/mhauser/mha/conf/mha.cnf'
alias mha_log='tail -f /home/mhauser/mha/logs/manager.log'
```

#### 8. SSH 접속 테스트
```
masterha_check_ssh --conf=/home/mhauser/mha/conf/mha.cnf
```
```
sshcheck
```

#### 9. Replication 테스트
```
masterha_check_repl --conf=/home/mhauser/mha/conf/mha.cnf
```
```
replcheck
```

#### 10. mha failover 실행
```
masterha_manager --conf=/home/mhauser/mha/conf/mha.cnf
```
```
tail -f /home/mhauser/mha/logs/manager.log
```
```
mha_log
```

```
nohup masterha_manager --conf=/home/mhauser/mha/conf/mha.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /home/mhauser/mha/logs/manager.log 2>&1 &
```
```
mha_start
```
