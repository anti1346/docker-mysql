### 리플리케이션 계정 생성
 ```
 CREATE USER 'replication_user'@'192.168.56.0/24' IDENTIFIED BY 'password';
 ```
 ```
 GRANT REPLICATION SLAVE ON *.* TO 'replication_user';
 ```
 ```
 flush privileges;
 ```

## 마스터 서버
##### 마스터 상태 확인(bin-log(File) 파일 및 Position 확인)
```
mysql -h localhost -uroot -p'mysqlpassword' -e "show master status\G" | egrep 'File|Position'
```

## 슬레이브 서버
#### 복제 중지(stop slave)
```
mysql -h localhost -uroot -p'mysqlpassword' -e "stop slave"
```
#### 복제 설정 리셋(reset slave)
```
mysql -h localhost -uroot -p'mysqlpassword' -e "reset slave"
```
#### 슬레이브 복제 설정(sql)
```
mysql -h localhost -uroot -p'mysqlpassword' -e "
CHANGE MASTER TO
MASTER_HOST='192.168.56.101',
MASTER_USER='replication_user',
MASTER_PASSWORD='password',
MASTER_LOG_FILE='mysql-bin.000007',
MASTER_LOG_POS=154;
"
```
#### 슬레이브 다시 시작(start slave)
```
mysql -h localhost -uroot -p'mysqlpassword' -e "start slave"
```
#### 슬레이브 상태 확인
```
mysql -hlocalhost -uroot -p'mysqlpassword' -e "show slave status\G" | egrep 'Master_Host|Read_Master_Log_Pos|Slave_IO_State|Slave_IO_Running|Slave_SQL_Running|Seconds_Behind_Master|Slave_SQL_Running_State'
```
```
mysql -hlocalhost -uroot -p'mysqlpassword' -e "show slave status\G" | egrep 'Slave_IO_Running|Slave_SQL_Running|Seconds_Behind_Master'
```
```
mysql -hlocalhost -uroot -p'mysqlpassword' -e "show slave status\G"
```

## 마스터 서버
##### 슬레이브 호스트 확인
```
mysql -h localhost -uroot -p'mysqlpassword' -e "SHOW SLAVE HOSTS"
```

