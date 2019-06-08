{% if grains['host'].startswith(('8dm', '8m'))%}
region: weur
datacenter: lhr08
consul_servers: "[\"10.0.8.2\", \"10.0.8.3\", \"10.0.8.4\"]"
{% elif grains['host'].startswith(('18dm', '18m'))%}
region: wnam
datacenter: pdx08
consul_servers: "[\"10.0.18.2\", \"10.0.18.3\", \"10.0.18.4\"]"
{% elif grains['host'].startswith(('28dm', '28m'))%}
region: weur
datacenter: lux08
consul_servers: "[\"10.0.28.2\", \"10.0.28.3\", \"10.0.28.4\""
{% endif %}
