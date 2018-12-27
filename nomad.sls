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

add nomad service:
  file.managed:
    - name: /etc/systemd/system/nomad.service
    {% if grains['host'] == 'deb9-01' %}
    - source: salt://nomad/nomad.service
    {% elif grains['host'] != 'deb9-01' %}
    - source: salt://nomad/nomad-client.service
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
    - source: salt://nomad/nomad.hcl
    - user: nomad
    - group: nomad
    - mode: 640


{% if grains['host'] == 'deb9-01' %}
server nomad config:
  file.managed:
    - name: /etc/nomad.d/server.hcl
    - source: salt://nomad/server.hcl
    - user: nomad
    - group: nomad
    - mode: 640
{% endif %}

{% if grains['host'] != 'deb9-01' %}
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
      {% if grains['host'] == 'deb9-01' %}
      - file: server nomad config
      {% elif grains['host'] != 'deb9-01' %}
      - file: client nomad config
      {% endif %}
