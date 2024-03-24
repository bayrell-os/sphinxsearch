if [ ! -d /data/sphinxsearch ]; then
    mkdir -p /data/sphinxsearch
fi

if [ ! -d /data/sphinxsearch/data ]; then
    mkdir -p /data/sphinxsearch/data
fi

if [ -n "$SPHINX_CONF" ]; then
    echo -e "$SPHINX_CONF" > /etc/sphinxsearch/sphinx.conf
fi

cat /etc/sphinxsearch/sphinx.example.conf >> /etc/sphinxsearch/sphinx.conf
