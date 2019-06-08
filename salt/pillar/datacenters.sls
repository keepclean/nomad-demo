{% if grains['host'].startswith(('8dm', '8m'))%}
datacenter: lhr08
{% elif grains['host'].startswith(('18dm', '18m'))%}
datacenter: pdx08
{% elif grains['host'].startswith(('28dm', '28m'))%}
datacenter: lux08
{% endif %}
