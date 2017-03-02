alter system set listener_networks='((name=XE)(local_listener= (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=localhost)(PORT=1521)))) (remote_listener= (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=localhost)(PORT=1521)))))' sid='XE' scope=spfile;
exit;
