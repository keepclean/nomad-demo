install nomad binary:
  file.managed:
    - name: /usr/local/bin/nomad
    - source: salt://nomad/nomad
    - user: root
    - group: root
    - mode: 755

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
