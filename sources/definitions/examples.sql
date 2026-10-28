
-- Use the existing database configured in manifest.yml

define warehouse DCM_DEMO_1_WH{{env_suffix}}
    with
        warehouse_size = '{{wh_size}}'
        auto_suspend = 300
        comment = 'For Quickstart Demo of DCM Projects'
;

-- Do not DEFINE DATABASE here.
-- The database already exists and contains the DCM project.

define schema {{database_name}}.ANALYTICS
    comment = 'For Task copying sample data into landing tables'
;

define table {{database_name}}.ANALYTICS.ALL_ITEMS(
    ITEM_NAME varchar,
    ITEM_ID varchar,
    ITEM_CATEGORY array
)
change_tracking = TRUE
;

define dynamic table {{database_name}}.ANALYTICS.DRINKS
    warehouse = DCM_DEMO_1_WH{{env_suffix}}
    target_lag = '6 hours'
    initialize = 'ON_CREATE'
as
select *
from {{database_name}}.ANALYTICS.ALL_ITEMS
where ARRAY_CONTAINS('DRINKS'::variant, ITEM_CATEGORY)
;

define role DCM_DEMO_1{{env_suffix}}_READ
;

grant USAGE on database {{database_name}}
    to role DCM_DEMO_1{{env_suffix}}_READ
;

grant USAGE on schema {{database_name}}.ANALYTICS
    to role DCM_DEMO_1{{env_suffix}}_READ
;

grant SELECT on ALL tables in schema {{database_name}}.ANALYTICS
    to role DCM_DEMO_1{{env_suffix}}_READ
;

grant SELECT on dynamic table {{database_name}}.ANALYTICS.DRINKS
    to role DCM_DEMO_1{{env_suffix}}_READ
;
