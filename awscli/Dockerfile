FROM python:3.6-alpine
MAINTAINER devops-team@parity.io

RUN pip install awscli

RUN <<EOR
cat > /etc/aws.config <<EOC
[default]                                                                                                                                       
s3 =                                                                                                                                            
  max_concurrent_requests = 20                                                                                                                  
  max_queue_size = 10000                                                                                                                        
  multipart_threshold = 64MB                                                                                                                    
  multipart_chunksize = 16MB                                                                                                                    
  max_bandwidth = 50MB/s                                                                                                                        
  use_accelerate_endpoint = false                                                                                                               
  addressing_style = path
EOC
EOR

ENV AWS_CONFIG_FILE /etc/aws.config

CMD /bin/sh
