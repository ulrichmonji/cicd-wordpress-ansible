# CICD du site web statique

## Prérequis
- Docker
- Ansible
- Jenkins

## Contexte et objectifs
Vous disposez d'un site web statique [disponible à cette adresse](https://github.com/diranetafen/static-website-example.git)

Le but de ce projet est de mettre en place un pipeline complet cicd sur votre application. Dans un premier temps, il faudra conteneuriser l'application.
Pour celà, quelques intructions pour vous orienter : 

- un squelette de **Dockerfile**  vous est fournie, il faut le compléter.
    Il faudrait refaire exactement les même étapes que celles dans le cours, à quelques différences prêt : 
- Pour lancer le conteneur après le build, voici un exemple de commande : 
 ```
docker run --name cont_name -d -e PORT=80 -p 80:80 $ID_DOCKERUB/$IMAGE_NAME:$IMAGE_TAG
 ```

- Le déploiement en **staging** et **production** sera fait sur des VMs et non dans Heroku
- On utilisera **Ansible** pour se faciliter la vie
    - Qui dit ansible dit créer des **playbooks** dans le repos github

- Pour vous aider, un vagranfile vous est fourni, ce dernier déploie : 
    - Le **serveur jenkins**, avec **docker** et **ansible** installé sur ce dernier
    - Les deux serveurs de **Staging** et **de Production**, aucun outil d'installé sur ces serveurs
    - Les trois serveurs sont joignables au niveau réseau



## Aide pour la partie déploiement avec ansible uniquement
- Un exemple d'inventaire, ansible.cfg, host_vars et group_vars sont fournis, vous pouvez vous en inspirer...
- Le playbook d'installation de docker (docker.yml) est fourni dans le dossier "ressources ansible"
- Un utilisateur jenkins existe sur les 3 machines crées, il sera utilisé comme user de connexion ansible
    - Le répertoire personnel du user jenkins est **/var/lib/jenkins**  sur les 3 serveurs
    - Cet utilisateur Jenkins ne possède pas de mot de passe, mais une paire de clés ssh.
        - Le couple de clés se trouve donc dans **/var/lib/jenkins/.ssh**
        - La clés publique est disponible sur les serveurs worker1 et worker2

        - Pour passer la clés dans les commandes ansible, utiliser l'option : --private-key <fichier de la clés privée>
          * Example : 
            ```
            ansible all -m ping --private-key /var/lib/jenkins/.ssh/id_rsa
            ```
    - la clés privée pourr être rajoutée comme secret dans le serveur jenkins, et être récupérée dans une variable
        * Exemple : 
        ```
        PRIVATE_KEY = credentials('private_key')
        ```
    - Cette clé privée  pourrait être passée dans les commandes ansible pour se connecter aux machines, vous pouvez la récupéer dans votre projet si vous le souhaiter (c'est pas obloigatoire), comme suit : 
        ```
        echo $PRIVATE_KEY > id_rsa
        chmod 600 id_rsa
        ```