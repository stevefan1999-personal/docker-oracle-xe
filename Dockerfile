FROM oraclelinux:7-slim
LABEL MAINTAINER="Adrian Png <adrian.png@fuzziebrain.com>"

ENV \
  # The only environment variable that should be changed!
  ORACLE_PASSWORD=Oracle18 \
  EM_GLOBAL_ACCESS_YN=Y \
  # DO NOT CHANGE 
  ORACLE_DOCKER_INSTALL=true \
  ORACLE_SID=XE \
  ORACLE_BASE=/opt/oracle \
  ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE \
  ORAENV_ASK=NO \
  RUN_FILE=runOracle.sh \
  SHUTDOWN_FILE=shutdownDb.sh \
  EM_REMOTE_ACCESS=enableEmRemoteAccess.sh \
  EM_RESTORE=reconfigureEm.sh \
  ORACLE_XE_RPM=oracle-database-xe-18c-1.0-1.x86_64.rpm \
  CHECK_DB_FILE=checkDBStatus.sh
    
COPY ./files/${ORACLE_XE_RPM} /tmp/

RUN yum install -y oracle-database-preinstall-18c oracle-instantclient18.3-basic oracle-instantclient18.3-sqlplus libaio libnsl && \
  yum install -y /tmp/${ORACLE_XE_RPM} && \
  rm -rf /tmp/${ORACLE_XE_RPM}

COPY ./scripts/*.sh ${ORACLE_BASE}/scripts/
COPY ./files/*.sql ${ORACLE_BASE}/scripts/

RUN chmod a+x -R ${ORACLE_BASE}/scripts

# 1521: Oracle listener
# 5500: Oracle Enterprise Manager (EM) Express listener.
EXPOSE 1521 5500

RUN mkdir -p ${ORACLE_BASE}/oradata
RUN chown oracle.oinstall ${ORACLE_BASE}/oradata
RUN /etc/init.d/oracle-xe-18c configure

# VOLUME [ "${ORACLE_BASE}/oradata" ]

HEALTHCHECK --interval=1m --start-period=2m --retries=10 \
  CMD "$ORACLE_BASE/scripts/$CHECK_DB_FILE"

CMD exec ${ORACLE_BASE}/scripts/${RUN_FILE}