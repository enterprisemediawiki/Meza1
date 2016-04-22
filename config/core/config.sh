#!/bin/bash

# meza install location
m_install=/opt # was :m_install=/root/mezadownloads
m_meza="$m_install/meza" # was: m_meza="$m_install/meza1"

# config dir
m_config="$m_meza/config"

# webserver variables
m_htdocs="$m_meza/htdocs" # was: m_htdocs="$m_www_meza/htdocs"
m_mediawiki="$m_htdocs/mediawiki"

# app locations
m_apache="/etc/httpd"