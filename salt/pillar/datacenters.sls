{% if grains['host'].startswith(('8dm', '8m'))%}
region: weur
datacenter: lhr08
consul_servers: "[\"10.0.8.2\"]"
{% elif grains['host'].startswith(('18dm', '18m'))%}
region: wnam
datacenter: pdx18
consul_servers: "[\"10.0.18.2\"]"
{% elif grains['host'].startswith(('28dm', '28m'))%}
region: weur
datacenter: ams28
consul_servers: "[\"10.0.28.2\"]"
{% endif %}
