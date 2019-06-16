base:
  '*':
    - common
    - consul
    - nomad
  'host:18dm\d+':
    - match: grain_pcre
    - baur.db
