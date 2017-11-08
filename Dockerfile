FROM centos:centos6
RUN yum install -y tar
### JDK ###
RUN yum install -y java-1.7.0-openjdk
ENV JAVA_HOME /usr/lib/jvm/jre

### Tomcat ###
ENV CATALINA_HOME /usr/local/tomcat6
ENV PATH $CATALINA_HOME/bin:$PATH
ENV TOMCAT_MAJOR 6
ENV TOMCAT_VERSION 6.0.45
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
RUN curl -SL https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz -o /tmp/tomcat.tar.gz 
RUN tar -xvf /tmp/tomcat.tar.gz -C /usr/local/ \
  && ln -s /usr/local/apache-tomcat-$TOMCAT_VERSION $CATALINA_HOME  \
  && rm -rf /tmp/tomcat.tar.gz
RUN sed -i "s'<welcome-file>index.html</welcome-file>'<welcome-file>index.jsp</welcome-file>'g" /usr/local/tomcat6/conf/web.xml
RUN sed -i 's/8080/800/g' /usr/local/tomcat6/conf/server.xml

#ADD docker-demo.war /usr/local/apache-tomcat-6.0.45/webapps/
ADD src/main/webapp /usr/local/apache-tomcat-6.0.45/webapps/ROOT

### run ###
EXPOSE 800
CMD ["catalina.sh", "run"]
