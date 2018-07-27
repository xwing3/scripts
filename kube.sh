function kncos {
  ENV=$( cat ~/.kube/ncos | fzf )
  gcloud container clusters get-credentials $ENV --zone europe-west1-b --project jlr-dl-ncos-qa
}
function kexec {
  if [ -z $1 ]
  then
    NS=$(kubectl get ns | fzf | awk "{print \$1}")
  else
    NS=$1
  fi
  POD=$(kubectl get pods -n $NS | fzf | awk "{print \$1}")
  CONTAINERS=$(kubectl get pods $POD -n $NS -o jsonpath='{.spec.containers[*].name}')
  COUNT_CONTAINERS=$(echo $CONTAINERS | wc -w | tr -d ' ')
  if [ "$COUNT_CONTAINERS" -gt "1" ]
  then
    kubectl exec -it $POD -c $(echo $CONTAINERS | tr " " "\n" | fzf) -n $NS -- sh
  else
    kubectl exec -it $POD -n $NS -- sh
  fi
}
function klogs {
  if [ -z $1 ]
  then
    NS=$(kubectl get ns | fzf | awk "{print \$1}")
  else
    NS=$1
  fi
  POD=$(kubectl get pods -n $NS | fzf | awk "{print \$1}")
  CONTAINERS=$(kubectl get pod $POD -n $NS -o jsonpath='{.spec.containers[*].name}')
  COUNT_CONTAINERS=$(echo $CONTAINERS | wc -w | tr -d ' ')
  if [ "$COUNT_CONTAINERS" -gt "1" ]
  then
    kubectl logs $POD -c $(echo $CONTAINERS | tr " " "\n" | fzf) -n $NS -f
  else
    kubectl logs $POD -n $NS -f
  fi
}
function kdel {
  NS=$(kubectl get ns | fzf | awk "{print \$1}")
  POD=$(kubectl get pods -n $NS | fzf | awk "{print \$1}")
  kubectl delete pod $POD -n $NS
}
function kedit {
  if [ -z $1 ]
  then
    kubectl edit $(kubectl get deployments -o name | fzf)
  else
    kubectl edit $(kubectl get \$1 -o name | fzf)
  fi
}
function wkp {
  NS=$(kubectl get ns | fzf | awk "{print \$1}")
  watch "kubectl get pods -n $NS"
}