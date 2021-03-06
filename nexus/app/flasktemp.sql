CREATE TABLE IF NOT EXISTS `users` (
  `userid` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` int(11) NOT NULL,
  `apikey` varchar(255) NOT NULL unique,
  `keyenabled` int(11) NOT NULL,
  `lastlogin` datetime NOT NULL,
  `lastpwdchange` datetime NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`userid`)
);

CREATE TABLE IF NOT EXISTS `uuidtable` (
  `uuid` int(11) NOT NULL,
  `name` varchar(3000) DEFAULT NULL,
  PRIMARY KEY (`uuid`)
);


INSERT INTO `users` (`userid`, `password`, `role`, `apikey`,`keyenabled`) VALUES
('abhi1@gmail.com', '48dc8d29308eb256edc76f25def07251', 1, 'token1', 0),
('abhi2@gmail.com', '48dc8d29308eb256edc76f25def07251', 2, 'token2', 1),
('abhi3@gmail.com', '48dc8d29308eb256edc76f25def07251', 3, 'token3', 1),
('abhi4@gmail.com', '48dc8d29308eb256edc76f25def07251', 4, 'token4', 1),
('abhi5@gmail.com', '48dc8d29308eb256edc76f25def07251', 5, 'token5', 1),
('abhi6@gmail.com', '48dc8d29308eb256edc76f25def07251', 6, 'token6', 1),
('abhi7@gmail.com', '48dc8d29308eb256edc76f25def07251', 7, 'token7', 1);


create table relidtable(
  relid int not null primary key,
  reltype varchar(1000) not null,
  startuuid int not null,
  enduuid int not null,
  foreign key (startuuid) references uuidtable(uuid) on delete cascade on update cascade,
  foreign key (enduuid) references uuidtable(uuid) on delete cascade on update cascade);


CREATE TABLE `tasks` (
  `taskid` int not null auto_increment primary key,
  `ownerid` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `createdate` datetime NOT NULL,
  `iscrawled` int NOT NULL,
  foreign key (`ownerid`) references `users`(`userid`) on delete cascade on update cascade
);

CREATE TABLE `taskusers` (
  `taskid` int not null,
  `userid` varchar(255) NOT NULL,
  primary key(`taskid`, `userid`),
  foreign key (`taskid`) references `tasks`(`taskid`) on delete cascade on update cascade,
  foreign key (`userid`) references `users`(`userid`) on delete cascade on update cascade
);

CREATE TRIGGER `after_tasks_insert` AFTER INSERT ON `tasks`
 FOR EACH ROW INSERT INTO taskusers(userid, taskid)
VALUES (NEW.ownerid, NEW.taskid);

CREATE TRIGGER `after_users_insert` AFTER INSERT ON `users`
 FOR EACH ROW INSERT INTO tasks(name, ownerid, description, createdate, iscrawled)
VALUES ('Default task', NEW.userid,  'Default task of the user', NOW(), 0);

CREATE TABLE `tasklog` (
  `taskid` int not null,
  `userid` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `jsondump` MEDIUMTEXT not null,
  `dumpdate` datetime NOT NULL,
  foreign key (`taskid`) references `tasks`(`taskid`) on delete cascade on update cascade,
  foreign key (`userid`) references `users`(`userid`) on delete cascade on update cascade
);


CREATE TABLE `changetable` (
  `changeid` bigint(20) not null auto_increment primary key,
  `taskid` int NOT NULL,
  `pushedby` varchar(255) NOT NULL,
  `verifiedby` varchar(255) NOT NULL,
  `verifydate` datetime NOT NULL,
  `pushdate` datetime NOT NULL,
  `fetchdate` datetime NOT NULL,
  `source_url` varchar(1000) NOT NULL,
  foreign key (`taskid`, `pushedby`) references `taskusers`(`taskid`,`userid`) on delete cascade on update cascade,
  foreign key (`verifiedby`) references `users`(`userid`) on delete cascade on update cascade
);


##the changeid will be in increasing order for any recent changes
##so for a uuid, based on the largest/recent uuid you can get the latest change was because of whom
CREATE TABLE `uuidlabels` (
  `changeid` bigint(20) not null,
  `uuid` int not null,
  `label` varchar(100) NOT NULL, #100 is the new size for any label, will have to follow that
  `changetype` int not null,
  foreign key (`changeid`) references `changetable`(`changeid`) on delete cascade on update cascade,
  foreign key (`uuid`) references `uuidtable`(`uuid`) on delete cascade on update cascade
);
alter table uuidlabels add unique(changeid, uuid, label);


CREATE TABLE `relidlabels` (
  `changeid` bigint(20) not null,
  `relid` int not null,
  `label` varchar(100) NOT NULL,
  `changetype` int not null,
  foreign key (`changeid`) references `changetable`(`changeid`) on delete cascade on update cascade,
  foreign key (`relid`) references `relidtable`(`relid`) on delete cascade on update cascade
);
alter table relidlabels add unique(changeid, relid, label);

##TODO: assertion on this table that if changetype is 1,2,0 then oldpropvalue and newpropvalue will behave accordingly
CREATE TABLE `uuidprops` (
  `changeid` bigint(20) not null,
  `uuid` int not null,
  `propname` varchar(100) NOT NULL, #100 is the new size for any propname, will have to follow that
  `oldpropvalue`  text,
  `newpropvalue` text,
  `changetype` int not null,
  foreign key (`changeid`) references `changetable`(`changeid`) on delete cascade on update cascade,
  foreign key (`uuid`) references `uuidtable`(`uuid`) on delete cascade on update cascade
);
alter table uuidprops add unique(changeid, uuid, propname);


CREATE TABLE `relidprops` (
  `changeid` bigint(20) not null,
  `relid` int not null,
  `propname` varchar(100) NOT NULL,
  `oldpropvalue`  text,
  `newpropvalue` text,
  `changetype` int not null,
  foreign key (`changeid`) references `changetable`(`changeid`) on delete cascade on update cascade,
  foreign key (`relid`) references `relidtable`(`relid`) on delete cascade on update cascade
);
alter table relidprops add unique(changeid, relid, propname);
