CLUSTER_NAME=capstone-project # this is fixed, only initialized once


# Get input parameters
while getopts "i:r:a:" opt
do
   case "$opt" in
      i ) IMAGE_NAME="$OPTARG" ;;
      r ) REGION="$OPTARG" ;;
      a ) ACCOUNT_ID="$OPTARG" ;;
   esac
done

# set default values if not provided
IMAGE_NAME=${IMAGE_NAME:-udacity-capstone}
REGION=${REGION:-us-east-1}
ACCOUNT_ID=${ACCOUNT_ID:-774630093804}

ECR_REPOSITORY_URI=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Build Docker image for Linux
docker buildx build --platform linux/amd64 -t $IMAGE_NAME .

# Login to AWS ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_REPOSITORY_URI

echo Pusing $IMAGE_NAME:latest to $ECR_REPOSITORY_URI/$IMAGE_NAME:latest

# Push to AWS ECR
docker tag $IMAGE_NAME:latest $ECR_REPOSITORY_URI/$IMAGE_NAME:latest
docker push $ECR_REPOSITORY_URI/$IMAGE_NAME:latest

# Check if cluster exists using list-clusters, if not create it
if ! aws eks list-clusters --region $REGION | grep $CLUSTER_NAME; then
    echo Creating cluster $CLUSTER_NAME
    eksctl create cluster --name $CLUSTER_NAME --region $REGION --zones=$REGION"a",$REGION"b"
fi

# Create a Kubernetes deployment for the Docker image and specify the 
kubectl create deployment udacity-capstone --port=3000 --image=$ECR_REPOSITORY_URI/$IMAGE_NAME:latest

# Expose the deployment to the internet
# kubectl expose deployment udacity-capstone --type=LoadBalancer --port=80 --target-port=3000


