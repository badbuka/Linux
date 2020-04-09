## Отчет о сертификатах openshift
```
ansible-playbook -v -i inventory.yaml playbooks/openshift-checks/certificate_expiry/easy-mode.yaml
```
## Диагностика сети
```
kubectl run --generator=run-pod/v1 tmp-shell --rm -i --tty --image nicolaka/netshoot -- /bin/bash
```
