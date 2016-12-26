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
RUN curl -SL "$TOMCAT_TGZ_URL" -o /tmp/tomcat.tar.gz \
 # && tar -xvf /tmp/tomcat.tar.gz -C /usr/local/ \
  && ln -s /usr/local/apache-tomcat-$TOMCAT_VERSION $CATALINA_HOME  \
  && rm -rf /tmp/tomcat.tar.gz

### Maven ###
ENV MAVEN_VERSION 3.2.3
RUN curl -sSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -o /usr/share/apache-maven-$MAVEN_VERSION-bin.tar.gz 
RUN mkdir /usr/share/maven \
  && tar -xvf /usr/share/apache-maven-$MAVEN_VERSION-bin.tar.gz -C /usr/share/maven \
##  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven/apache-maven-3.2.3/
ENV PATH $MAVEN_HOME/bin:$PATH

### Compile ###
WORKDIR /code
ADD pom.xml /code/pom.xml
#RUN ["mvn", "dependency:resolve"]
#RUN ["mvn", "verify"]
ADD src /code/src
RUN ["mvn", "package"]

### install ###
RUN curl -SL https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz -o /tmp/tomcat.tar.gz 
RUN tar -xvf /tmp/tomcat.tar.gz -C /usr/local/ \
  && ln -s /usr/local/apache-tomcat-$TOMCAT_VERSION $CATALINA_HOME  \
  && rm -rf /tmp/tomcat.tar.gz

RUN cp target/docker-demo.war /usr/local/apache-tomcat-6.0.45/webapps/

### run ###
EXPOSE 8080
CMD ["catalina.sh", "run"]
