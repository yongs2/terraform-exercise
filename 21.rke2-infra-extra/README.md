## Settings for metallb

- Check EXTERNAL-IP status before running

```sh
# kubectl get svc -A | grep Load
istio-system               istio-ingressgateway                          LoadBalancer   10.43.252.23    <pending>     15021:31774/TCP,80:31380/TCP,443:31390/TCP,31400:31400/TCP,15443:31286/TCP   15h
```

- modules/metallb_kind
  - Working with metallb after installation
  - Set up an IPAddressPool to be used by metallb

- Verify that EXTERNAL-IP is assigned after applying

```sh
# kubectl -n istio-system get svc istio-ingressgateway
NAME                   TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)
                         AGE
istio-ingressgateway   LoadBalancer   10.43.252.23   192.168.5.64   15021:31774/TCP,80:31380/TCP,443:31390/TCP,31400:31400/TCP,15443:31286/TCP   15h
```
