# Setup vpc
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --output text --query 'Vpc.VpcId')

aws ec2 create-tags --resources ${VPC_ID} --tags Key=Name,Value=kubernetes-the-hard-way

aws ec2 modify-vpc-attribute --vpc-id ${VPC_ID} --enable-dns-support '{"Value": true}'
aws ec2 modify-vpc-attribute --vpc-id ${VPC_ID} --enable-dns-hostnames '{"Value": true}'

# Setup subnet
SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id ${VPC_ID} \
  --cidr-block 10.0.1.0/24 \
  --output text --query 'Subnet.SubnetId')

aws ec2 create-tags --resources ${SUBNET_ID} --tags Key=Name,Value=kubernetes

# Setup igw
INTERNET_GATEWAY_ID=$(aws ec2 create-internet-gateway --output text --query 'InternetGateway.InternetGatewayId')

aws ec2 create-tags --resources ${INTERNET_GATEWAY_ID} --tags Key=Name,Value=k8s-IGW

aws ec2 attach-internet-gateway --internet-gateway-id ${INTERNET_GATEWAY_ID} --vpc-id ${VPC_ID}

# Setup route table
ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id ${VPC_ID} --output text --query 'RouteTable.RouteTableId')

aws ec2 create-tags --resources ${ROUTE_TABLE_ID} --tags Key=Name,Value=kubernetes

aws ec2 associate-route-table --route-table-id ${ROUTE_TABLE_ID} --subnet-id ${SUBNET_ID}

aws ec2 create-route --route-table-id ${ROUTE_TABLE_ID} --destination-cidr-block 0.0.0.0/0 --gateway-id ${INTERNET_GATEWAY_ID}

# Setup defualt security group k8s master
SECURITY_GROUP_ID=$(aws ec2 create-security-group \
  --group-name kubernetes \
  --description "Kubernetes security group" \
  --vpc-id ${VPC_ID} \
  --output text --query 'GroupId')

aws ec2 create-tags --resources ${SECURITY_GROUP_ID} --tags Key=Name,Value=kubernetes

aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP_ID} --protocol all --cidr 10.0.0.0/16
aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP_ID} --protocol all --cidr 10.200.0.0/16
aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP_ID} --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP_ID} --protocol tcp --port 6443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP_ID} --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP_ID} --protocol icmp --port -1 --cidr 0.0.0.0/0


# Setup Security Group for config node
SECURITY_GROUP_ID2=$(aws ec2 create-security-group \
  --group-name configureNodeRule \
  --description "only allow SSH" \
  --vpc-id ${VPC_ID} \
  --output text --query 'GroupId')
aws ec2 create-tags --resources ${SECURITY_GROUP_ID2} --tags Key=Name,Value=configureNodeRule
aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP_ID2} --protocol tcp --port 22 --cidr 0.0.0.0/0

# Setup EC2 instance for config node
 instance_id0=$(aws ec2 run-instances \
    --associate-public-ip-address \
    --image-id ami-0440d3b780d96b29d \
    --count 1 \
    --key-name vockey \
    --security-group-ids ${SECURITY_GROUP_ID2}  \
    --instance-type t2.micro \
    --private-ip-address 10.0.1.99 \
    --subnet-id ${SUBNET_ID} \
    --block-device-mappings='{"DeviceName": "/dev/xvda", "Ebs": { "VolumeSize": 8 }, "NoDevice": "" }'\
    --output text --query 'Instances[].InstanceId')
 
  aws ec2 create-tags --resources ${instance_id0} --tags "Key=Name,Value=configure-node"
  echo "configure-node is created"


