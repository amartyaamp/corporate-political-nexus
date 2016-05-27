import MySQLdb as mysqldb
from app.sqldb import MetaSQLDB

class Entity:

    ## create table uuidtable(uuid bigint(20) not null auto_increment primary key, name varchar(255));
    ## very very important BIGINT!

    def __init__(self, name):
        self.uuid = None
        self.name = name ##TODO: but what if the primary name changes?
        #self.uri = uri #TODO: will decide afterwards 
        from app.constants import META_TABLE_UUID
        self.tablename  = META_TABLE_UUID
        self.dbwrap = MetaSQLDB()

    def create(self):
        query = "insert into uuidtable(name) values('%s');"
        query = query %(self.name)
        

        cursor = self.dbwrap.connectAndCursor()
        numrows = cursor.execute(query)
        self.uuid =  cursor.lastrowid
        self.dbwrap.commitAndClose() ##what if something breaks? TODO!

        print numrows

class Link: ##chossing this name instead of a relation
    ## startnode and ennode can be foregin keys here constraints
    ## finally the table query! 
    ## create table relidtable(relid bigint(20) not null auto_increment primary key, reltype varchar(255), startuuid bigint(20), enduuid bigint(20), foreign key (startuuid) references uuidtable(uuid) on delete cascade on update cascade,  foreign key (enduuid) references uuidtable(uuid) on delete cascade on update cascade); 



    def __init__(self, reltype, startuuid, enduuid):

        self.relid = None ##this helps in tracking bugs really! 
        self.reltype = reltype ##RULE: once a type given to a relation, it's always given
        self.startuuid = startuuid
        self.enduuid = enduuid
        from app.constants import META_TABLE_RELID
        self.tablename  = META_TABLE_RELID
        self.dbwrap = MetaSQLDB()

    def create(self):
        query = "insert into relidtable(reltype, startuuid, enduuid ) values('%s', %s, %s);"
        query = query %(self.reltype, self.startuuid, self.enduuid)
        

        cursor = self.dbwrap.connectAndCursor()
        numrows = cursor.execute(query)
        self.relid =  cursor.lastrowid
        self.dbwrap.commitAndClose()

        print numrows

class HyperEdge:
    pass