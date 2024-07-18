# Configuration via vpc_config.yaml

Le fichier de configuration contient plusieurs sections

## Regions (section regions)

Une liste de configurations pour chaqune des 2 regions supportées

* name : (requis) le nom de la région p.e.
* enabled : (optionnel) par défaut "true" pour region1 et "false" pour region2. Mettre à true pour que le déploiement se fasse dans une région

## Les "Spokes" prod, non-prod et dev (section spokes)

Contient une section de configuration commune aux "spokes" et des configurations plus ou moins similaires pour chaqune des "spokes". Par défaut contient 3 environnement "spoke" (development, nonproduction et production) mais c'est optionnel - on peut en rajouter, changer les noms ou enlever.

### Configuration commune (section common)

Par défaut les seus éléments de configuration (optionnel) sont:

* al_env_ip_range : un CIDR sommarisé pour les plages d'adresse des "spoke"
* spoke_common_routes: Contient (si le cas) le routage commun pour toutes les "spokes", par défaut 2 routes optionnelles
  * rt_nat_to_internet: route vers Internet à traver la passerelle NAT
  * rt_windows_activation: route vers les serveurs d'activation Windows fournis par Google

Ces routes peuvent être complémentées ou invalidées par des routes définis au niveau d'une envrronnement "spoke" ou encore plus bas au niveau d'un sous-environnement ("base" ou "restricted") en utilisant une plus haute priorité

### Configuration par "spoke"

Pour chacun des environnements "spoke" il y a une partie de configuration commune et des configurations à part pour chacun des sous-environnements (par défaut "base" et "restricted")

La différence entre "base" et "restricted" est le niveau de décurité. Les sous-environnements "restricted" utilisent les contrôles de service de type périmètre qui sécurisent les charges de travail.

#### Configuration commune

Les paramètres suivants sont communs pour les sous-environnements "base" et "restricted"

* env_code: (requis) un code d'une lettre pour l'environnement, retrouvé dans les noms des ressources. Par défaut c'est "d" pour development, "n" pour nonproduction et "p" pour production
* env_enabled : (optionnel) par défaut false, mettre à true pour provisionner l'environnement "spoke"
* nat_igw_enabled: (optionnel) contrôle le provisionnement de la fonction NAT, par défaut false, mettre à true pour configurer les passerelles NAT. Aussi implicitement conditionne le provisionnement de la route NAT vers Internet et des ressources "cloud router" associées
* windows_activation_enabled: (optionnel) contrôle le provisionnement de la route rt_windows_activation. Par défaut false.
* enable_hub_and_spoke_transitivity: (optionnel) contrôle le déploiement des VM dans les VPC partagées pour permettre le routage inter-spoke. Par défaut false.
* router_ha_enabled: (optionnel) contrôle le déploiement du deuxième ressource "cloud router" dans chaque zone de disponibilité. Le "cloud router" est gratuit mais pas le trafic BGP à travers. Par défaut false.
* mode: (optionnel) 2 valeurs possibles mettre "spoke" ou "hub", c'est utilisé dans le code. Par défaut "spoke" à ce niveau.

#### Paramétrage de configuration pour "base" et "restricted"

Le paramétrage des 2 sous-environnement est pareil, les routes et adressage pourraient varier.

Les paramètres suivants sont communs:

* env_type: (optionnel) C'est une composante des noms des ressources. Par défaut "shared-base" pour "base" et "shared-restricted" pour "restricted".
* enabled: (optionnel) Par défaut false. Si true, le sous-environnement est déployé.
* private_service_cidr: (optionnel) C'est dans une plage d'adresses dans un format CIDR qui, si configuré, permet de provisionner la connectivité "Private Service Access", nécessaire pour accéder des services comme Cloud SQL ou Cloud Filestore (partage fichiers).
* private_service_connect_ip: (requis) c'est l'adresse qui va attre assignée à un point de connexion privé, utilisé pour accéder en mode privé aux services API Google.
* subnets: (requis) le paramétrage des sous-réseaux. Par défaut les sets de sous-réseaux qui sont configurés sont les suivants:

  * id=primary: (optionnel) utilisée pour des charges de travail, avec des plages d'adresse pour chaque région. C'est optionnel de provisionner un sous-réseau au niveau d'une région.

    * secondary_ranges: (optionnel) on peut en configurer plusieurs plages d'adresses secondaires, encore optionnellement dans une ou les 2 régions, associées avec le sous-réseau primaire. Les seuls paramétres fournis (par région) sont
      * range_suffix: (requis) un string arbitraire qui est utilisé pour générer les noms des sous-réseaux secondaires
      * ip_cidr_ranges: (requis) la plage d'adresse du sous-réseau secondaire en format CIDR, pour chaque région ou on désire provisionner un sous-réseau secondaire.
    * id: (requis) un identificateur unique du sous-réseau, qui apparait dans le nom généré de la ressource créé. On peut provisionner
    * description: (optionnel) une description de la fonction du sous-réseau
    * ip_ranges: (requis) une place d'adresse de sous-réseau par région en format CIDR. Pour chaque région pour laquelle on y spécifie une plage CIDR un sous-réseau à part sera provisionné.
    * subnet_suffix: (optionnel) un string qui sera rajouté à la fin du nom généré du sous-réseau
    * flow_logs: (optionnel) un paramétrage personnalisé des "flow-log" par rapport aux valeurs défaut. Les champs suivants peuvent être spécifiés:
      * enable: (optionnel) défaut "false". Si true, les flow_log sont activés pour le sous-réseau
      * interval: (optionnel) défaut 5 secondes
      * medatata: (optionnel) défaut INCLUDE_ALL_METADATA
      * metadata_fields (optionnel) défaut vide
    * private_access: (optionnel) défaut false. Contrôle si l'accès privé Google (PGA) est  activé au niveau du sous-réseau. Comme il s'agit de provisionner une ressource de type "forwarding-rule" l'activation implique des coûts.
  * id=proxy: (optionnel) utilisé pour des ressources qui utilisent le proxy Envoy déployé dans un VPC. Exemples : équilibreur applicatif ou "proxy TCP" interne, API Gateway. Il y a des paramètres

    * id: (requis) un identificateur unique du sous-réseau, qui apparait dans le nom généré de la ressource créé. On peut provisionner
    * description: (optionnel) une description de la fonction du sous-réseau
    * ip_ranges: (requis) une place d'adresse de sous-réseau par région en format CIDR. Pour chaque région pour laquelle on y spécifie une plage CIDR un sous-réseau à part sera provisionné.
    * subnet_suffix: (optionnel) un string qui sera rajouté à la fin du nom généré du sous-réseau
    * flow_logs: (optionnel) un paramétrage personnalisé des "flow-log" par rapport aux valeurs défaut. Les champs suivants peuvent être spécifiés:
      * enable: (optionnel) défaut "false". Si true, les flow_log sont activés pour le sous-réseau
      * interval: (optionnel) défaut 5 secondes
      * medatata: (optionnel) défaut INCLUDE_ALL_METADATA
      * metadata_fields (optionnel) défaut vide
    * role et purpose sont requis est spécifiques aux sous-réseaux de type "proxy". Laisser les valeurs défaut (role = ACTIVE et purpose = REGIONAL_MANAGED_PROXY)

## Le paramétrage des ressources partagées (section common)

Par défaut l'environnement "common" contient 2 sous-environnements:

* dns-hub: (requis) héberge les zones DNS partagées avec "DNS peering"  ainsi que pour la résolution DNS entre le nuage et le "on-site"
* net-hub: (requis) héberge les VPC partagés de type "hub", un par environnement (production, nonproduction et development) et sous-environnement (base et restricted)

Pour le sous-environnement "net-hub" il y a des configurations spécifiques,voir la confifuration yaml pour détails.
