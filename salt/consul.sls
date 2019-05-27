{%- set version = "1.5.1" %}
download consul binary:
  file.managed:
    - name: /opt/artefacts/consul_{{ version }}_linux_amd64.zip
    - source: https://releases.hashicorp.com/consul/{{ version }}/consul_{{ version }}_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/consul/{{ version }}/consul_{{ version }}_SHA256SUMS
    - makedirs: True

install consul binary:
  archive.cmd_unzip:
    - zip_file: /opt/artefacts/consul_{{ version }}_linux_amd64.zip
    - dest: /usr/local/bin/

add consul user:
  user.present:
    - name: consul
    - shell: /bin/false
    - home: /etc/consul.d
    - system: True

/opt/consul:
  file.directory:
    - user: consul
    - group: consul

add consul service:
  file.managed:
    - name: /etc/systemd/system/consul.service
    - source: salt://templates/consul/consul.service
    - user: consul
    - group: consul

/etc/consul.d:
  file.directory:
    - user: consul
    - group: consul

{% set consul_servers = ('8dm1', '8dm2', '8dm3') %}

{% if grains['host'] in  consul_servers %}
server consul config:
  file.managed:
    - name: /etc/consul.d/server.json
    - source: salt://templates/consul/server.json
    - user: consul
    - group: consul
    - mode: 640
{% endif %}

{% if grains['host'] not in consul_servers %}
client consul config:
  file.managed:
    - name: /etc/consul.d/client.json
    - source: salt://templates/consul/client.json
    - user: consul
    - group: consul
    - mode: 640
{% endif %}

run consul service:
  service.running:
    - name: consul
    - enable: True
    - no_block: True
    - watch:
      {% if grains['host'] == consul_servers %}
      - file: server consul config
      {% elif grains['host'] != consul_servers %}
      - file: client consul config
      {% endif %}
