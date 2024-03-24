# Sphinx Search Docker Image

Add custom patch:
```
<?xml version="1.1" encoding="utf-8"?>
<patch>
  <operations>
    <operation type="replace">
      <path>/template/yaml/services/_var_app_name_/environment/SPHINX_CONF</path>
      <value>
<SPHINX_CONF>
# Sphinx config
</SPHINX_CONF>
      </value>
    </operation>
  </operations>
</patch>
```

If container is first run, enter to container and run:
```
indexer --all
supervisorctl restart sphinx
```
