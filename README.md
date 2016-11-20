# power_networks

Let's follow power elites.
Indian version of littlesis.org

##Setup Instructions

sudo apt-get install python-mysqldb

ipython and django follow this:
sudo apt-get install python-django-extensions
http://codeispoetry.me/index.php/django-ipython-notebook-shell/
To fire ipython for a project: 
python manage.py shell_plus --notebook

bigautofield custom


##Scrapy
1. sudo su -
2. pip install scrapy


##FuzzyWuzzy
git clone git://github.com/seatgeek/fuzzywuzzy.git fuzzywuzzy
cd fuzzywuzzy
sudo python setup.py install
Also install: sudo apt-get install python-Levenshtein

On the Japan Server the password for mysql is root.

Importing sql file: 
mysql -u root -p
create database powernetworks
source powernetworks.sql
