openstack stack create -t test/nginx.yaml\
 -e test/lib/heat-iaas/resources.yaml\
 -e resources-ubuntu.yaml\
 --parameter key=$1\
 --parameter image=$2\
 --parameter flavor=$3\
 --parameter public_network=$4\
 --wait\
 test-nginx
