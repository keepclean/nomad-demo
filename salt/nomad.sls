{%- set version = "0.9.1" %}
install nomad binary:
  archive.extracted:
    - name: /usr/local/bin/
    - source: https://releases.hashicorp.com/nomad/{{ version }}/nomad_{{ version }}_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/nomad/{{ version }}/nomad_{{ version }}_SHA256SUMS
    - user: root
    - group: root
    - enforce_toplevel: False

add nomad user:
  user.present:
    - name: nomad
    - shell: /bin/false
    - home: /etc/nomad.d
    - system: True

/opt/nomad:
  file.directory:
    - user: nomad
    - group: nomad

{% from 'consul.sls' import consul_servers %}

add nomad service:
  file.managed:
    - name: /etc/systemd/system/nomad.service
    {% if grains['host'] in consul_servers %}
    - source: salt://templates/nomad/nomad.service
    {% elif grains['host'] not in consul_servers %}
    - source: salt://templates/nomad/nomad-client.service
    {% endif %}
    - user: nomad
    - group: nomad

/etc/nomad.d:
  file.directory:
    - user: nomad
    - group: nomad

common nomad config:
  file.managed:
    - name: /etc/nomad.d/nomad.hcl
    - source: salt://templates/nomad/nomad.hcl
    - user: nomad
    - group: nomad
    - mode: 640


{% if grains['host'] in consul_servers %}
server nomad config:
  file.managed:
    - name: /etc/nomad.d/server.hcl
    - source: salt://templates/nomad/server.hcl
    - user: nomad
    - group: nomad
    - mode: 640
{% endif %}

{% if grains['host'] not in consul_servers %}
client nomad config:
  file.managed:
    - name: /etc/nomad.d/client.hcl
    - source: salt://nomad/client.hcl
    - user: nomad
    - group: nomad
    - mode: 640
{% endif %}

run nomad service:
  service.running:
    - name: nomad
    - enable: True
    - no_block: True
    - watch:
      - file: common nomad config
      {% if grains['host'] in consul_servers %}
      - file: server nomad config
      {% elif grains['host'] not in consul_servers %}
      - file: client nomad config
      {% endif %}
