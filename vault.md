## Install vault  ubuntu 18.04
## https://developer.hashicorp.com/vault/install#Linux
## https://releases.hashicorp.com/vault/


go to releases and grab: https://releases.hashicorp.com/vault/1.15.4/vault_1.15.4_linux_amd64.zip

## Install curl
```sh
sudo apt  install curl
sudo apt install unzip
```

## Install vault from release

```sh
curl --silent -Lo /tmp/vault.zip https://releases.hashicorp.com/vault/1.15.4/vault_1.15.4_linux_amd64.zip

cd /tmp
unzip vault.zip
sudo mv vault /usr/local/bin
vault version
```

## TO-TEST: run Dev in Interactive mode - FOR TESTING ONLY

```sh
vault server -dev
```

**set address on a separate terminal**

```sh
export VAULT_ADDR='http://10.0.0.50:8200' 
```

## Run vault with persistent storage
**add vault.d file and content to sudo vi /etc/vault/config.hcl**
**Im using my url for: "api_addr": "http://vault.sosotech.io:8200"**
- you can use the server IP if you dont have a domain name

```sh
sudo mkdir /opt/vault-data
sudo mkdir /etc/vault.d
sudo vi /etc/vault.d/vault.hcl   
```

**add vault.service file and content to /etc/vault/config.hcl**
```sh
sudo nano /etc/systemd/system/vault.service    # create the service file here
```

## Add group and user to server
```sh
sudo groupadd --system vault
sudo useradd --system -g vault vault
```

## Give permission to directories
```sh
sudo chown -R vault:vault /etc/vault.d /opt/vault-data
sudo chmod 750 /etc/vault.d
sudo chmod 770 /opt/vault-data
```

```sh
sudo systemctl daemon-reload
sudo systemctl status vault.service
sudo systemctl start vault.service
```

## Now on the Vault UI
- for key share, enter [5]
- for key Threshold, enter [3]

## Enter downloaded key details
- enter 3 keys for keys_base64 when prompted to UNSEAL Vault
- enter the root_token, NEXT 

## OPTIONAL: get vault logs

```sh
sudo journalctl -xe | grep vault
sudo journalctl -u vault
```


## To login externally usings ecret-hvs
```sh
vault login hvs.jn45Mka8D97DcbkEvjJX0l3L
  [OR]
vault login -method=token token=hvs.jn45Mka8D97DcbkEvjJX0l3L
```

## my-url
https://vault-cluster-http-vault-6abaa721.j.cloud.hashicorp.com/


## My vault real creds

```json
{
  "keys": [
    "aaa94843568c65d9eec96083c5850f0c023437969a19cf1c5452a48a778fe405e5",
    "0aa8f1bb5a08e2a03c14c98b1318471548a38f3ea52ff85885abf88f99242871bd",
    "d88b69c9a2e5ac2d1542459c0e6ddab6269047e338c3c7359b6e56dff646333d1a",
    "5453c2e7a0e83a30bebf2ba7a00e75fa6d6a9363e57f6e7cc8fb42b9f01801f462",
    "65bcc9913cd024df1c249eaccd32348a8cd51e8cdc84391b2b05621ce159c41e07"
  ],
  "keys_base64": [
    "qqlIQ1aMZdnuyWCDxYUPDAI0N5aaGc8cVFKkineP5AXl",
    "Cqjxu1oI4qA8FMmLExhHFUijjz6lL/hYhav4j5kkKHG9",
    "2ItpyaLlrC0VQkWcDm3atiaQR+M4w8c1m25W3/ZGMz0a",
    "VFPC56DoOjC+vyunoA51+m1qk2Plf258yPtCufAYAfRi",
    "ZbzJkTzQJN8cJJ6szTI0iozVHozchDkbKwViHOFZxB4H"
  ],
  "root_token": "hvs.jn45Mka8D97DcbkEvjJX0l3L"
}
```


https://github.com/btkrausen/hashicorp/blob/master/vault/config_files/vault.service
