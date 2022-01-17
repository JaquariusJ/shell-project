dockerRegistry=172.27.96.200:5000
projectName=cgn
deployName=mysql
mirror=mysql:8.0.25
port=3306
namespace=4pd
replicas=1
mysqlPassword=root123
nfsServer=172.27.96.200
nfsPath=/root/cgn/nfs/mysql/data
#构建yaml
echo "---------------------构建yaml文件---------------------"
K8S_DEPLOY_TEMPLATE_PATH="template.yaml"
K8S_DEPLOY_PATH="${deployName}.yaml"

echo "$K8S_DEPLOY_TEMPLATE_PATH"
echo "cp -a $K8S_DEPLOY_TEMPLATE_PATH $K8S_DEPLOY_PATH"
cp -a $K8S_DEPLOY_TEMPLATE_PATH $K8S_DEPLOY_PATH
sed -i  "s#{{ projectName }}#${projectName}#g" $K8S_DEPLOY_PATH
sed -i  "s#{{ deployName }}#${deployName}#g" $K8S_DEPLOY_PATH
sed -i  "s#{{ port }}#${port}#g" $K8S_DEPLOY_PATH
sed -i  "s#{{ namespace }}#${namespace}#g" $K8S_DEPLOY_PATH
sed -i  "s#{{ mirror }}#${mirror}#g" $K8S_DEPLOY_PATH
sed -i  "s#{{ replicas }}#${replicas}#g" $K8S_DEPLOY_PATH
sed -i  "s#{{ cpuRequest }}#${cpuRequest}#g" $K8S_DEPLOY_PATH
sed -i  "s#{{ cpuLimit }}#${cpuLimit}#g" $K8S_DEPLOY_PATH
sed -i  "s#{{ memoryRequest }}#${memoryRequest}#g" $K8S_DEPLOY_PATH
sed -i  "s#{{ memoryLimit }}#${memoryLimit}#g" $K8S_DEPLOY_PATH
sed -i  "s#{{ mysqlPassword }}#${mysqlPassword}#g" $K8S_DEPLOY_PATH
sed -i  "s#{{ nfsServer }}#${nfsServer}#g" $K8S_DEPLOY_PATH
sed -i  "s#{{ nfsPath }}#${nfsPath}#g" $K8S_DEPLOY_PATH

#echo "---------------------------构建docker镜像-------------------------"
#echo "docker build -t ${mirror} ."
#docker build -t ${mirror} .

#echo "---------------------------上传docker镜像-------------------------"
#echo "docker push ${mirror}"

#docker push ${mirror}
echo "---------------------------重新构建configmap-------------------------"
ns_exists=`kubectl get ns | grep ${namespace}`
if [ ! "$ns_exists" ];then
	kubectl create namespace ${namespace} && echo "kubectl create namespace ${namespace}"
fi
cm_exists=`kubectl get cm -n ${namespace} | grep ${deployName}`
if [ "$cm_exists" ];then
	kubectl delete cm ${deployName}-conf -n ${namespace} && echo "kubectl delete cm ${deployName}-conf -n ${namespace}"
fi

echo "kubectl create cm ${deployName}-conf --from-file=./project/conf/my.cnf -n ${namespace}"
kubectl create cm ${deployName}-conf --from-file=./project/conf/my.cnf -n ${namespace}

echo "---------------------------发布应用-------------------------"
echo "k delete -f ${deployName}.yaml"
kubectl delete -f ${deployName}.yaml
echo "k apply -f ${deployName}.yaml"
kubectl apply -f ${deployName}.yaml
