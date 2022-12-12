sudo apt update
sudo snap install microk8s --classic --channel=1.21/stable
sudo usermod -a -G microk8s $USER && newgrp microk8s
sudo chown -f -R $USER ~/.kube
microk8s enable dns storage dashboard ingress metallb:10.64.140.43-10.64.140.49
microk8s start
echo "alias kubectl='microk8s kubectl'" >> .bashrc && source .bashrc

wget https://github.com/kubernetes-sigs/kustomize/releases/download/v3.2.0/kustomize_3.2.0_linux_amd64 -O kustomize
sudo chmod +x ./kustomize
sudo cp ./kustomize /usr/bin/

git clone https://github.com/kubeflow/manifests.git -b v1.5-branch
cd manifests
while ! kustomize build example | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 10; done
