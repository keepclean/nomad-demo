{%- set version = "1.5.1" %}
install consul binary:
  archive.extracted:
    - name: /usr/local/bin
    - source: https://releases.hashicorp.com/consul/{{ version }}/consul_{{ version }}_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/consul/{{ version }}/consul_{{ version }}_SHA256SUMS
    - user: root
    - group: root
    - enforce_toplevel: False

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

{% set agent = "server" %}
{% if 'dm' not in grains['host'] %}
  {% set agent = "client" %}
{% endif %}

consul config:
  file.managed:
    - name: /etc/consul.d/{{ agent }}.json
    - source: salt://templates/consul/{{ agent }}.json
    - user: consul
    - group: consul
    - mode: 640
    - template: jinja

run consul service:
  service.running:
    - name: consul
    - enable: True
    - no_block: True
    - watch:
      - file: consul config
