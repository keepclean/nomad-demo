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

{% set agent = "server" %}
{% if 'dm' not in grains['host'] %}
  {% set agent = "client" %}
{% endif %}

add nomad service:
  file.managed:
    - name: /etc/systemd/system/nomad.service
    - source: salt://templates/nomad/nomad-{{ agent }}.service
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
    - template: jinja


{{ agent }} nomad config:
  file.managed:
    - name: /etc/nomad.d/{{ agent }}.hcl
    - source: salt://templates/nomad/{{ agent }}.hcl
    - user: nomad
    - group: nomad
    - mode: 640

run nomad service:
  service.running:
    - name: nomad
    - enable: True
    - no_block: True
    - watch:
      - file: common nomad config
      - file: {{ agent }} nomad config
