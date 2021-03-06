--   The contents of this file are subject to the license and copyright
--   detailed in the LICENSE and NOTICE files at the root of the source
--   tree and available online at
--   
--   https://github.com/CILEA/dspace-cris/wiki/License
--
-- SQL commands to upgrade the database schema to a live DSpace-CRIS
--
-- DUMP YOUR DATABASE FIRST. DUMP YOUR DATABASE FIRST. DUMP YOUR DATABASE FIRST. DUMP YOUR DATABASE FIRST.
-- DUMP YOUR DATABASE FIRST. DUMP YOUR DATABASE FIRST. DUMP YOUR DATABASE FIRST. DUMP YOUR DATABASE FIRST.
-- DUMP YOUR DATABASE FIRST. DUMP YOUR DATABASE FIRST. DUMP YOUR DATABASE FIRST. DUMP YOUR DATABASE FIRST.
create table cris_do (id int4 not null, crisID varchar(255) unique, sourceID varchar(255), sourceRef varchar(255), status bool, uuid varchar(255) not null unique, timestampCreated timestamp, timestampLastModified timestamp, typo_id int4, primary key (id), unique (sourceID, sourceRef));
create table cris_do_box (id int4 not null, collapsed bool not null, externalJSP varchar(255), priority int4 not null, shortName varchar(255) unique, title varchar(255), unrelevant bool not null, visibility int4, typeDef_id int4, primary key (id));
create table cris_do_box2con (cris_do_box_id int4 not null, jdyna_containable_id int4 not null);
create table cris_do_etab (id int4 not null, ext varchar(255), mandatory bool not null, mime varchar(255), priority int4 not null, shortName varchar(255) unique, title varchar(255), visibility int4, displayTab_id int4, typeDef_id int4, primary key (id));
create table cris_do_etab2box (cris_do_etab_id int4 not null, cris_do_box_id int4 not null);
create table cris_do_no (id int4 not null, endDate timestamp, startDate timestamp, positionDef int4, status bool, timestampCreated timestamp, timestampLastModified timestamp, uuid varchar(255) not null unique, scopeDef_id int4, sourceID varchar(255), sourceRef varchar(255), parent_id int4, typo_id int4, primary key (id), unique (positionDef, typo_id, parent_id));
create table cris_do_no_pdef (id int4 not null, accessLevel int4, advancedSearch bool not null, fieldmin_col int4, fieldmin_col_unit varchar(255), fieldmin_row_unit varchar(255), fieldmin_row int4, help text, label varchar(255), labelMinSize int4 not null, labelMinSizeUnit varchar(255), mandatory bool not null, newline bool not null, onCreation bool, priority int4 not null, repeatable bool not null, shortName varchar(255) unique, showInList bool not null, simpleSearch bool not null, rendering_id int4 unique, primary key (id));
create table cris_do_no_prop (id int4 not null, endDate timestamp, startDate timestamp, lockDef int4, positionDef int4 not null, visibility int4, scopeDef_id int4, value_id int4 unique, parent_id int4, typo_id int4, primary key (id), unique (positionDef, typo_id, parent_id));
create table cris_do_no_tp (id int4 not null, label varchar(255), shortName varchar(255), accessLevel int4, help varchar(4000), inline bool not null, mandatory bool not null, newline bool not null, priority int4 not null, repeatable bool not null, primary key (id));
create table cris_do_no_tp2pdef (cris_do_no_tp_id int4 not null, cris_do_no_pdef_id int4 not null);
create table cris_do_pdef (id int4 not null, accessLevel int4, advancedSearch bool not null, fieldmin_col int4, fieldmin_col_unit varchar(255), fieldmin_row_unit varchar(255), fieldmin_row int4, help text, label varchar(255), labelMinSize int4 not null, labelMinSizeUnit varchar(255), mandatory bool not null, newline bool not null, onCreation bool, priority int4 not null, repeatable bool not null, shortName varchar(255) unique, showInList bool not null, simpleSearch bool not null, rendering_id int4 unique, primary key (id));
create table cris_do_prop (id int4 not null, endDate timestamp, startDate timestamp, lockDef int4, positionDef int4 not null, visibility int4, scopeDef_id int4, value_id int4 unique, parent_id int4, typo_id int4, primary key (id), unique (positionDef, typo_id, parent_id));
create table cris_do_tab (id int4 not null, ext varchar(255), mandatory bool not null, mime varchar(255), priority int4 not null, shortName varchar(255) unique, title varchar(255), visibility int4, typeDef_id int4, primary key (id));
create table cris_do_tab2box (cris_do_tab_id int4 not null, cris_do_box_id int4 not null);
create table cris_do_tp (id int4 not null, label varchar(255), shortName varchar(255), primary key (id));
create table cris_do_tp2notp (cris_do_tp_id int4 not null, cris_do_no_tp_id int4 not null);
create table cris_do_tp2pdef (cris_do_tp_id int4 not null, cris_do_pdef_id int4 not null);
create table cris_do_wfile (id int4 not null, fileDescription text, labelAnchor varchar(255), showPreview bool not null, widgetSize int4, useInStatistics bool not null, primary key (id));
create table cris_do_wpointer (id int4 not null, display text, filtro text, indexName varchar(255), widgetSize int4, target varchar(255), urlPath varchar(255), filterExtended text, primary key (id));
create table cris_orgunit (id int4 not null, crisID varchar(255) unique, sourceID varchar(255), sourceRef varchar(255), status bool, uuid varchar(255) not null unique, timestampCreated timestamp, timestampLastModified timestamp, primary key (id), unique (sourceID, sourceRef));
create table cris_ou_box (id int4 not null, collapsed bool not null, externalJSP varchar(255), priority int4 not null, shortName varchar(255) unique, title varchar(255), unrelevant bool not null, visibility int4, primary key (id));
create table cris_ou_box2con (cris_ou_box_id int4 not null, jdyna_containable_id int4 not null);
create table cris_ou_etab (id int4 not null, ext varchar(255), mandatory bool not null, mime varchar(255), priority int4 not null, shortName varchar(255) unique, title varchar(255), visibility int4, displayTab_id int4, primary key (id));
create table cris_ou_etab2box (cris_ou_etab_id int4 not null, cris_ou_box_id int4 not null);
create table cris_ou_no (id int4 not null, endDate timestamp, startDate timestamp, positionDef int4, status bool, timestampCreated timestamp, timestampLastModified timestamp, uuid varchar(255) not null unique, scopeDef_id int4, sourceID varchar(255), sourceRef varchar(255), parent_id int4, typo_id int4, primary key (id), unique (positionDef, typo_id, parent_id));
create table cris_ou_no_pdef (id int4 not null, accessLevel int4, advancedSearch bool not null, fieldmin_col int4, fieldmin_col_unit varchar(255), fieldmin_row_unit varchar(255), fieldmin_row int4, help text, label varchar(255), labelMinSize int4 not null, labelMinSizeUnit varchar(255), mandatory bool not null, newline bool not null, onCreation bool, priority int4 not null, repeatable bool not null, shortName varchar(255) unique, showInList bool not null, simpleSearch bool not null, rendering_id int4 unique, primary key (id));
create table cris_ou_no_prop (id int4 not null, endDate timestamp, startDate timestamp, lockDef int4, positionDef int4 not null, visibility int4, scopeDef_id int4, value_id int4 unique, parent_id int4, typo_id int4, primary key (id), unique (positionDef, typo_id, parent_id));
create table cris_ou_no_tp (id int4 not null, label varchar(255), shortName varchar(255), accessLevel int4, help varchar(4000), inline bool not null, mandatory bool not null, newline bool not null, priority int4 not null, repeatable bool not null, primary key (id));
create table cris_ou_no_tp2pdef (cris_ou_no_tp_id int4 not null, cris_ou_no_pdef_id int4 not null);
create table cris_ou_pdef (id int4 not null, accessLevel int4, advancedSearch bool not null, fieldmin_col int4, fieldmin_col_unit varchar(255), fieldmin_row_unit varchar(255), fieldmin_row int4, help text, label varchar(255), labelMinSize int4 not null, labelMinSizeUnit varchar(255), mandatory bool not null, newline bool not null, onCreation bool, priority int4 not null, repeatable bool not null, shortName varchar(255) unique, showInList bool not null, simpleSearch bool not null, rendering_id int4 unique, primary key (id));
create table cris_ou_prop (id int4 not null, endDate timestamp, startDate timestamp, lockDef int4, positionDef int4 not null, visibility int4, scopeDef_id int4, value_id int4 unique, parent_id int4, typo_id int4, primary key (id), unique (positionDef, typo_id, parent_id));
create table cris_ou_tab (id int4 not null, ext varchar(255), mandatory bool not null, mime varchar(255), priority int4 not null, shortName varchar(255) unique, title varchar(255), visibility int4, primary key (id));
create table cris_ou_tab2box (cris_ou_tab_id int4 not null, cris_ou_box_id int4 not null);
create table cris_ou_wfile (id int4 not null, fileDescription text, labelAnchor varchar(255), showPreview bool not null, widgetSize int4, useInStatistics bool not null, primary key (id));
create table cris_ou_wpointer (id int4 not null, display text, filtro text, indexName varchar(255), widgetSize int4, target varchar(255), urlPath varchar(255), primary key (id));
create table cris_pj_box (id int4 not null, collapsed bool not null, externalJSP varchar(255), priority int4 not null, shortName varchar(255) unique, title varchar(255), unrelevant bool not null, visibility int4, primary key (id));
create table cris_pj_box2con (cris_pj_box_id int4 not null, jdyna_containable_id int4 not null);
create table cris_pj_etab (id int4 not null, ext varchar(255), mandatory bool not null, mime varchar(255), priority int4 not null, shortName varchar(255) unique, title varchar(255), visibility int4, displayTab_id int4, primary key (id));
create table cris_pj_etab2box (cris_pj_etab_id int4 not null, cris_pj_box_id int4 not null);
create table cris_pj_no (id int4 not null, endDate timestamp, startDate timestamp, positionDef int4, status bool, timestampCreated timestamp, timestampLastModified timestamp, uuid varchar(255) not null unique, scopeDef_id int4, sourceID varchar(255), sourceRef varchar(255), parent_id int4, typo_id int4, primary key (id), unique (positionDef, typo_id, parent_id));
create table cris_pj_no_pdef (id int4 not null, accessLevel int4, advancedSearch bool not null, fieldmin_col int4, fieldmin_col_unit varchar(255), fieldmin_row_unit varchar(255), fieldmin_row int4, help text, label varchar(255), labelMinSize int4 not null, labelMinSizeUnit varchar(255), mandatory bool not null, newline bool not null, onCreation bool, priority int4 not null, repeatable bool not null, shortName varchar(255) unique, showInList bool not null, simpleSearch bool not null, rendering_id int4 unique, primary key (id));
create table cris_pj_no_prop (id int4 not null, endDate timestamp, startDate timestamp, lockDef int4, positionDef int4 not null, visibility int4, scopeDef_id int4, value_id int4 unique, parent_id int4, typo_id int4, primary key (id), unique (positionDef, typo_id, parent_id));
create table cris_pj_no_tp (id int4 not null, label varchar(255), shortName varchar(255), accessLevel int4, help varchar(4000), inline bool not null, mandatory bool not null, newline bool not null, priority int4 not null, repeatable bool not null, primary key (id));
create table cris_pj_no_tp2pdef (cris_pj_no_tp_id int4 not null, cris_pj_no_pdef_id int4 not null);
create table cris_pj_pdef (id int4 not null, accessLevel int4, advancedSearch bool not null, fieldmin_col int4, fieldmin_col_unit varchar(255), fieldmin_row_unit varchar(255), fieldmin_row int4, help text, label varchar(255), labelMinSize int4 not null, labelMinSizeUnit varchar(255), mandatory bool not null, newline bool not null, onCreation bool, priority int4 not null, repeatable bool not null, shortName varchar(255) unique, showInList bool not null, simpleSearch bool not null, rendering_id int4 unique, primary key (id));
create table cris_pj_prop (id int4 not null, endDate timestamp, startDate timestamp, lockDef int4, positionDef int4 not null, visibility int4, scopeDef_id int4, value_id int4 unique, parent_id int4, typo_id int4, primary key (id), unique (positionDef, typo_id, parent_id));
create table cris_pj_tab (id int4 not null, ext varchar(255), mandatory bool not null, mime varchar(255), priority int4 not null, shortName varchar(255) unique, title varchar(255), visibility int4, primary key (id));
create table cris_pj_tab2box (cris_pj_tab_id int4 not null, cris_pj_box_id int4 not null);
create table cris_pj_wfile (id int4 not null, fileDescription text, labelAnchor varchar(255), showPreview bool not null, widgetSize int4, useInStatistics bool not null, primary key (id));
create table cris_pj_wpointer (id int4 not null, display text, filtro text, indexName varchar(255), widgetSize int4, target varchar(255), urlPath varchar(255), primary key (id));
create table cris_project (id int4 not null, crisID varchar(255) unique, sourceID varchar(255), sourceRef varchar(255), status bool, uuid varchar(255) not null unique, timestampCreated timestamp, timestampLastModified timestamp, primary key (id), unique (sourceID, sourceRef));
create table cris_relpref (id int4 not null, itemID int4, priority int4 not null, relationType varchar(255), sourceUUID varchar(255), status varchar(255), targetUUID varchar(255), primary key (id));
create table cris_rp_box (id int4 not null, collapsed bool not null, externalJSP varchar(255), priority int4 not null, shortName varchar(255) unique, title varchar(255), unrelevant bool not null, visibility int4, primary key (id));
create table cris_rp_box2con (cris_rp_box_id int4 not null, jdyna_containable_id int4 not null);
create table cris_rp_etab (id int4 not null, ext varchar(255), mandatory bool not null, mime varchar(255), priority int4 not null, shortName varchar(255) unique, title varchar(255), visibility int4, displayTab_id int4, primary key (id));
create table cris_rp_etab2box (cris_rp_etab_id int4 not null, cris_rp_box_id int4 not null);
create table cris_rp_no (id int4 not null, endDate timestamp, startDate timestamp, positionDef int4, status bool, timestampCreated timestamp, timestampLastModified timestamp, uuid varchar(255) not null unique, scopeDef_id int4, sourceID varchar(255), sourceRef varchar(255), parent_id int4, typo_id int4, primary key (id), unique (positionDef, typo_id, parent_id));
create table cris_rp_no_pdef (id int4 not null, accessLevel int4, advancedSearch bool not null, fieldmin_col int4, fieldmin_col_unit varchar(255), fieldmin_row_unit varchar(255), fieldmin_row int4, help text, label varchar(255), labelMinSize int4 not null, labelMinSizeUnit varchar(255), mandatory bool not null, newline bool not null, onCreation bool, priority int4 not null, repeatable bool not null, shortName varchar(255) unique, showInList bool not null, simpleSearch bool not null, rendering_id int4 unique, primary key (id));
create table cris_rp_no_prop (id int4 not null, endDate timestamp, startDate timestamp, lockDef int4, positionDef int4 not null, visibility int4, scopeDef_id int4, value_id int4 unique, parent_id int4, typo_id int4, primary key (id), unique (positionDef, typo_id, parent_id));
create table cris_rp_no_tp (id int4 not null, label varchar(255), shortName varchar(255), accessLevel int4, help varchar(4000), inline bool not null, mandatory bool not null, newline bool not null, priority int4 not null, repeatable bool not null, primary key (id));
create table cris_rp_no_tp2pdef (cris_rp_no_tp_id int4 not null, cris_rp_no_pdef_id int4 not null);
create table cris_rp_pdef (id int4 not null, accessLevel int4, advancedSearch bool not null, fieldmin_col int4, fieldmin_col_unit varchar(255), fieldmin_row_unit varchar(255), fieldmin_row int4, help text, label varchar(255), labelMinSize int4 not null, labelMinSizeUnit varchar(255), mandatory bool not null, newline bool not null, onCreation bool, priority int4 not null, repeatable bool not null, shortName varchar(255) unique, showInList bool not null, simpleSearch bool not null, rendering_id int4 unique, primary key (id));
create table cris_rp_prop (id int4 not null, endDate timestamp, startDate timestamp, lockDef int4, positionDef int4 not null, visibility int4, scopeDef_id int4, value_id int4 unique, parent_id int4, typo_id int4, primary key (id), unique (positionDef, typo_id, parent_id));
create table cris_rp_tab (id int4 not null, ext varchar(255), mandatory bool not null, mime varchar(255), priority int4 not null, shortName varchar(255) unique, title varchar(255), visibility int4, primary key (id));
create table cris_rp_tab2box (cris_rp_tab_id int4 not null, cris_rp_box_id int4 not null);
create table cris_rp_wfile (id int4 not null, fileDescription text, labelAnchor varchar(255), showPreview bool not null, widgetSize int4, useInStatistics bool not null, primary key (id));
create table cris_rp_wpointer (id int4 not null, display text, filtro text, indexName varchar(255), widgetSize int4, target varchar(255), urlPath varchar(255), primary key (id));
create table cris_rpage (id int4 not null, crisID varchar(255) unique, sourceID varchar(255), sourceRef varchar(255), status bool, uuid varchar(255) not null unique, epersonID int4 unique, namesTimestampLastModified timestamp, timestampCreated timestamp, timestampLastModified timestamp, primary key (id), unique (sourceID, sourceRef));
create table cris_statsubscription (id int4 not null, epersonID int4 not null, freq int4 not null, typeDef int4, handle_or_uuid varchar(255), primary key (id));
create table cris_subscription (id int4 not null, epersonID int4 not null, typeDef int4, uuid varchar(255), primary key (id));
create table cris_ws_criteria (id int4 not null, criteria varchar(255), enabled bool not null, filter varchar(255), primary key (id));
create table cris_ws_user (id int4 not null, enabled bool not null, password varchar(255), username varchar(255), showHiddenMetadata bool not null, fromIP varchar(255), toIP varchar(255), token varchar(255), timestampCreated timestamp, timestampLastModified timestamp, typeDef varchar(255), primary key (id));
create table cris_ws_user2crit (cris_ws_user_id int4 not null, criteria_id int4 not null, unique (criteria_id));
create table jdyna_box_message (id int4 not null, body varchar(4000), showInEdit bool not null, showInPublicView bool not null, useBodyAsKeyMessageBundle bool not null, elementAfter_id int4, parent_id int4, primary key (id));
create table jdyna_containable (DTYPE varchar(31) not null, id int4 not null, externalJSP varchar(255), cris_rp_pdef_fk int4, cris_pj_pdef_fk int4, cris_ou_pdef_fk int4, cris_rp_no_pdef_fk int4, cris_pj_no_pdef_fk int4, cris_ou_no_pdef_fk int4, cris_rp_no_tp int4, cris_pj_no_tp int4, cris_ou_no_tp_fk int4, cris_do_no_tp_fk int4, cris_do_no_pdef_fk int4, cris_do_pdef_fk int4, primary key (id));
create table jdyna_scopedefinition (id int4 not null, label varchar(255), primary key (id));
create table jdyna_values (DTYPE varchar(31) not null, id int4 not null, sortValue varchar(255), dateValue timestamp, textValue text, linkdescription varchar(255), linkvalue varchar(255), fileextension varchar(255), filefolder varchar(255), filemime varchar(255), filename varchar(255), doubleValue float8, rpvalue int4, projectvalue int4, ouvalue int4, dovalue int4, primary key (id));
create table jdyna_widget_date (id int4 not null, maxYear int4, minYear int4, time bool not null, primary key (id));
create table jdyna_widget_link (id int4 not null, labelHeaderLabel varchar(255), labelHeaderURL varchar(255), widgetSize int4 not null, primary key (id));
create table jdyna_widget_number (id int4 not null, max float8, min float8, precisionDef int4 not null, widgetSize int4, primary key (id));
create table jdyna_widget_text (id int4 not null, collisioni bool, widgetcol int4, measurementUnitCol varchar(255), measurementUnitRow varchar(255), widgetrow int4, htmlToolbar varchar(255), multilinea bool not null, regex varchar(255), primary key (id));
alter table cris_do add constraint FK3D8EBCB124A63AA7 foreign key (typo_id) references cris_do_tp;
alter table cris_do_box add constraint FK29BBA93D1ED73E00 foreign key (typeDef_id) references cris_do_tp;
alter table cris_do_box2con add constraint FK2532FECD1C4ABF89 foreign key (jdyna_containable_id) references jdyna_containable;
alter table cris_do_box2con add constraint FK2532FECDF2FA5297 foreign key (cris_do_box_id) references cris_do_box;
alter table cris_do_etab add constraint FKDBAEBDEC23AF2F7 foreign key (displayTab_id) references cris_do_tab;
alter table cris_do_etab add constraint FKDBAEBDE1ED73E00 foreign key (typeDef_id) references cris_do_tp;
alter table cris_do_etab2box add constraint FK9C9E0537F2FA5297 foreign key (cris_do_box_id) references cris_do_box;
alter table cris_do_etab2box add constraint FK9C9E053776BE0976 foreign key (cris_do_etab_id) references cris_do_etab;
alter table cris_do_no add constraint FKC3CB15F7A7AEA5D28579ac0f foreign key (scopeDef_id) references jdyna_scopedefinition;
alter table cris_do_no add constraint FK8579AC0FF32D30FE foreign key (typo_id) references cris_do_no_tp;
alter table cris_do_no add constraint FK8579AC0F92C6C975 foreign key (parent_id) references cris_do;
create index cris_do_no_pprop_idx on cris_do_no_prop (parent_id);
alter table cris_do_no_prop add constraint FKC8A841F5A7AEA5D29eb9e193 foreign key (scopeDef_id) references jdyna_scopedefinition;
alter table cris_do_no_prop add constraint FK9EB9E193331D8A0B foreign key (typo_id) references cris_do_no_pdef;
alter table cris_do_no_prop add constraint FKC8A841F5E52079D79eb9e193 foreign key (value_id) references jdyna_values;
alter table cris_do_no_prop add constraint FK9EB9E193548C257E foreign key (parent_id) references cris_do_no;
alter table cris_do_no_tp2pdef add constraint FKEE06779B6EAF91EA foreign key (cris_do_no_pdef_id) references cris_do_no_pdef;
alter table cris_do_no_tp2pdef add constraint FKEE06779B5EBB4E96 foreign key (cris_do_no_tp_id) references cris_do_no_tp;
create index cris_do_pprop_idx on cris_do_prop (parent_id);
alter table cris_do_prop add constraint FKC8A841F5A7AEA5D2dbfe631 foreign key (scopeDef_id) references jdyna_scopedefinition;
alter table cris_do_prop add constraint FKDBFE631BBAA874 foreign key (typo_id) references cris_do_pdef;
alter table cris_do_prop add constraint FKC8A841F5E52079D7dbfe631 foreign key (value_id) references jdyna_values;
alter table cris_do_prop add constraint FKDBFE63192C6C975 foreign key (parent_id) references cris_do;
alter table cris_do_tab add constraint FK29BBEB071ED73E00 foreign key (typeDef_id) references cris_do_tp;
alter table cris_do_tab2box add constraint FKC44947E09A14BB03 foreign key (cris_do_tab_id) references cris_do_tab;
alter table cris_do_tab2box add constraint FKC44947E0F2FA5297 foreign key (cris_do_box_id) references cris_do_box;
alter table cris_do_tp2notp add constraint FKDB5908A55EBB4E96 foreign key (cris_do_no_tp_id) references cris_do_no_tp;
alter table cris_do_tp2notp add constraint FKDB5908A51EEE761 foreign key (cris_do_tp_id) references cris_do_tp;
alter table cris_do_tp2pdef add constraint FKDB59C63D349FFEF5 foreign key (cris_do_pdef_id) references cris_do_pdef;
alter table cris_do_tp2pdef add constraint FKDB59C63D1EEE761 foreign key (cris_do_tp_id) references cris_do_tp;
alter table cris_ou_box2con add constraint FK1DF575281C4ABF89 foreign key (jdyna_containable_id) references jdyna_containable;
alter table cris_ou_box2con add constraint FK1DF575289B33F69D foreign key (cris_ou_box_id) references cris_ou_box;
alter table cris_ou_etab add constraint FK5DDC8B63DA71BC0C foreign key (displayTab_id) references cris_ou_tab;
alter table cris_ou_etab2box add constraint FKBC2A5A3C9B33F69D foreign key (cris_ou_box_id) references cris_ou_box;
alter table cris_ou_etab2box add constraint FKBC2A5A3C57562B52 foreign key (cris_ou_etab_id) references cris_ou_etab;
alter table cris_ou_no add constraint FKC3CB15F7A7AEA5D2861768d4 foreign key (scopeDef_id) references jdyna_scopedefinition;
alter table cris_ou_no add constraint FK861768D412DD8273 foreign key (typo_id) references cris_ou_no_tp;
alter table cris_ou_no add constraint FK861768D461AD7352 foreign key (parent_id) references cris_orgunit;
create index cris_ou_no_pprop_idx on cris_ou_no_prop (parent_id);
alter table cris_ou_no_prop add constraint FKC8A841F5A7AEA5D2977c57ee foreign key (scopeDef_id) references jdyna_scopedefinition;
alter table cris_ou_no_prop add constraint FK977C57EEDFE24D40 foreign key (typo_id) references cris_ou_no_pdef;
alter table cris_ou_no_prop add constraint FKC8A841F5E52079D7977c57ee foreign key (value_id) references jdyna_values;
alter table cris_ou_no_prop add constraint FK977C57EE67A17973 foreign key (parent_id) references cris_ou_no;
alter table cris_ou_no_tp2pdef add constraint FK5BD19F609DF7F510 foreign key (cris_ou_no_tp_id) references cris_ou_no_tp;
alter table cris_ou_no_tp2pdef add constraint FK5BD19F60893F7CE4 foreign key (cris_ou_no_pdef_id) references cris_ou_no_pdef;
create index cris_ou_pprop_idx on cris_ou_prop (parent_id);
alter table cris_ou_prop add constraint FKC8A841F5A7AEA5D25de185b6 foreign key (scopeDef_id) references jdyna_scopedefinition;
alter table cris_ou_prop add constraint FK5DE185B64F4B3769 foreign key (typo_id) references cris_ou_pdef;
alter table cris_ou_prop add constraint FKC8A841F5E52079D75de185b6 foreign key (value_id) references jdyna_values;
alter table cris_ou_prop add constraint FK5DE185B661AD7352 foreign key (parent_id) references cris_orgunit;
alter table cris_ou_tab2box add constraint FKBD0BBE3B9B33F69D foreign key (cris_ou_box_id) references cris_ou_box;
alter table cris_ou_tab2box add constraint FKBD0BBE3B8083565D foreign key (cris_ou_tab_id) references cris_ou_tab;
alter table cris_pj_box2con add constraint FKB34E213C1C4ABF89 foreign key (jdyna_containable_id) references jdyna_containable;
alter table cris_pj_box2con add constraint FKB34E213CA73EC203 foreign key (cris_pj_box_id) references cris_pj_box;
alter table cris_pj_etab add constraint FK7FFD77CF258F9F32 foreign key (displayTab_id) references cris_pj_tab;
alter table cris_pj_etab2box add constraint FKD1E730A842939FA0 foreign key (cris_pj_etab_id) references cris_pj_etab;
alter table cris_pj_etab2box add constraint FKD1E730A8A73EC203 foreign key (cris_pj_box_id) references cris_pj_box;
alter table cris_pj_no add constraint FKC3CB15F7A7AEA5D286208040 foreign key (scopeDef_id) references jdyna_scopedefinition;
alter table cris_pj_no add constraint FK8620804043AB27D8 foreign key (typo_id) references cris_pj_no_tp;
alter table cris_pj_no add constraint FK8620804057CB965E foreign key (parent_id) references cris_project;
create index cris_pj_no_pprop_idx on cris_pj_no_prop (parent_id);
alter table cris_pj_no_prop add constraint FKC8A841F5A7AEA5D22cd50402 foreign key (scopeDef_id) references jdyna_scopedefinition;
alter table cris_pj_no_prop add constraint FK2CD5040259E03865 foreign key (typo_id) references cris_pj_no_pdef;
alter table cris_pj_no_prop add constraint FKC8A841F5E52079D72cd50402 foreign key (value_id) references jdyna_values;
alter table cris_pj_no_prop add constraint FK2CD5040293FB9958 foreign key (parent_id) references cris_pj_no;
alter table cris_pj_no_tp2pdef add constraint FKF5B28ACC9D1E5375 foreign key (cris_pj_no_pdef_id) references cris_pj_no_pdef;
alter table cris_pj_no_tp2pdef add constraint FKF5B28ACCE48270E1 foreign key (cris_pj_no_tp_id) references cris_pj_no_tp;
create index cris_pj_pprop_idx on cris_pj_prop (parent_id);
alter table cris_pj_prop add constraint FKC8A841F5A7AEA5D280027222 foreign key (scopeDef_id) references jdyna_scopedefinition;
alter table cris_pj_prop add constraint FK800272226C4DA24E foreign key (typo_id) references cris_pj_pdef;
alter table cris_pj_prop add constraint FKC8A841F5E52079D780027222 foreign key (value_id) references jdyna_values;
alter table cris_pj_prop add constraint FK8002722257CB965E foreign key (parent_id) references cris_project;
alter table cris_pj_tab2box add constraint FK52646A4FE938BAEF foreign key (cris_pj_tab_id) references cris_pj_tab;
alter table cris_pj_tab2box add constraint FK52646A4FA73EC203 foreign key (cris_pj_box_id) references cris_pj_box;
alter table cris_rp_box2con add constraint FK157B9D801C4ABF89 foreign key (jdyna_containable_id) references jdyna_containable;
alter table cris_rp_box2con add constraint FK157B9D8074E43925 foreign key (cris_rp_box_id) references cris_rp_box;
alter table cris_rp_etab add constraint FKF407020BD46F7C6C foreign key (displayTab_id) references cris_rp_tab;
alter table cris_rp_etab2box add constraint FKB5693CE4A4C0618A foreign key (cris_rp_etab_id) references cris_rp_etab;
alter table cris_rp_etab2box add constraint FKB5693CE474E43925 foreign key (cris_rp_box_id) references cris_rp_box;
alter table cris_rp_no add constraint FKC3CB15F7A7AEA5D2863f697c foreign key (scopeDef_id) references jdyna_scopedefinition;
alter table cris_rp_no add constraint FK863F697CCD41D2CB foreign key (typo_id) references cris_rp_no_tp;
alter table cris_rp_no add constraint FK863F697CB926FEF2 foreign key (parent_id) references cris_rpage;
create index cris_rp_no_pprop_idx on cris_rp_no_prop (parent_id);
alter table cris_rp_no_prop add constraint FKC8A841F5A7AEA5D28f028046 foreign key (scopeDef_id) references jdyna_scopedefinition;
alter table cris_rp_no_prop add constraint FK8F02804693C00F98 foreign key (typo_id) references cris_rp_no_pdef;
alter table cris_rp_no_prop add constraint FKC8A841F5E52079D78f028046 foreign key (value_id) references jdyna_values;
alter table cris_rp_no_prop add constraint FK8F02804664ABB5CB foreign key (parent_id) references cris_rp_no;
alter table cris_rp_no_tp2pdef add constraint FKE27808E22E17E4 foreign key (cris_rp_no_pdef_id) references cris_rp_no_pdef;
alter table cris_rp_no_tp2pdef add constraint FKE27808519B2810 foreign key (cris_rp_no_tp_id) references cris_rp_no_tp;
create index cris_rp_pprop_idx on cris_rp_prop (parent_id);
alter table cris_rp_prop add constraint FKC8A841F5A7AEA5D2f40bfc5e foreign key (scopeDef_id) references jdyna_scopedefinition;
alter table cris_rp_prop add constraint FKF40BFC5EA3DF9BC1 foreign key (typo_id) references cris_rp_pdef;
alter table cris_rp_prop add constraint FKC8A841F5E52079D7f40bfc5e foreign key (value_id) references jdyna_values;
alter table cris_rp_prop add constraint FKF40BFC5EB926FEF2 foreign key (parent_id) references cris_rpage;
alter table cris_rp_tab2box add constraint FKB491E69374E43925 foreign key (cris_rp_box_id) references cris_rp_box;
alter table cris_rp_tab2box add constraint FKB491E6932FE88365 foreign key (cris_rp_tab_id) references cris_rp_tab;
alter table cris_ws_user2crit add constraint FKA8316B247442A824 foreign key (cris_ws_user_id) references cris_ws_user;
alter table cris_ws_user2crit add constraint FKA8316B24785E3061 foreign key (criteria_id) references cris_ws_criteria;
alter table jdyna_box_message add constraint FK74D7714673538EAA foreign key (elementAfter_id) references jdyna_containable;
alter table jdyna_containable add constraint FK504277E170F303EF foreign key (cris_ou_pdef_fk) references cris_ou_pdef;
alter table jdyna_containable add constraint FK504277E1BD0D909F foreign key (cris_rp_pdef_fk) references cris_rp_pdef;
alter table jdyna_containable add constraint FK504277E19DF7F4BA foreign key (cris_ou_no_tp_fk) references cris_ou_no_tp;
alter table jdyna_containable add constraint FK504277E1893F7C8E foreign key (cris_ou_no_pdef_fk) references cris_ou_no_pdef;
alter table jdyna_containable add constraint FK504277E1234E1AE8 foreign key (cris_pj_pdef_fk) references cris_pj_pdef;
alter table jdyna_containable add constraint FK504277E1349FFE9F foreign key (cris_do_pdef_fk) references cris_do_pdef;
alter table jdyna_containable add constraint FK504277E18D6C2EF4 foreign key (cris_rp_no_tp) references cris_rp_no_tp;
alter table jdyna_containable add constraint FK504277E1F6ADC6BD foreign key (cris_pj_no_tp) references cris_pj_no_tp;
alter table jdyna_containable add constraint FK504277E19D1E531F foreign key (cris_pj_no_pdef_fk) references cris_pj_no_pdef;
alter table jdyna_containable add constraint FK504277E1E22E178E foreign key (cris_rp_no_pdef_fk) references cris_rp_no_pdef;
alter table jdyna_containable add constraint FK504277E15EBB4E40 foreign key (cris_do_no_tp_fk) references cris_do_no_tp;
alter table jdyna_containable add constraint FK504277E16EAF9194 foreign key (cris_do_no_pdef_fk) references cris_do_no_pdef;
create index jdyna_values_dtype_idx on jdyna_values (DTYPE);
alter table jdyna_values add constraint FK51AA118F8565BC6B foreign key (dovalue) references cris_do;
alter table jdyna_values add constraint FK51AA118FA46E05CD foreign key (ouvalue) references cris_orgunit;
alter table jdyna_values add constraint FK51AA118F15A13386 foreign key (projectvalue) references cris_project;
alter table jdyna_values add constraint FK51AA118F92120815 foreign key (rpvalue) references cris_rpage;
create sequence CRIS_DYNAOBJ_SEQ;
create sequence CRIS_OU_SEQ;
create sequence CRIS_PROJECT_SEQ;
create sequence CRIS_RELPREF_SEQ;
create sequence CRIS_RPAGE_SEQ;
create sequence CRIS_STATSUBSCRIPTION_SEQ;
create sequence CRIS_SUBSCRIPTION_SEQ;
create sequence CRIS_TYPODYNAOBJ_SEQ;
create sequence CRIS_WS_CRITERIA_SEQ;
create sequence CRIS_WS_USER_SEQ;
create sequence JDYNA_BOX_SEQ;
create sequence JDYNA_CONTAINABLE_SEQ;
create sequence JDYNA_MESSAGEBOX_SEQ;
create sequence JDYNA_NESTEDOBJECT_SEQ;
create sequence JDYNA_PDEF_SEQ;
create sequence JDYNA_PROP_SEQ;
create sequence JDYNA_SCOPEDEF_SEQ;
create sequence JDYNA_TAB_SEQ;
create sequence JDYNA_TYPONESTEDOBJECT_SEQ;
create sequence JDYNA_VALUES_SEQ;
create sequence JDYNA_WIDGET_SEQ;