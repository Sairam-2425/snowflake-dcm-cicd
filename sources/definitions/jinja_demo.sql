
-- Loop through teams
{% for team in teams %}
    {% set team_name = team.name | upper %}

    -- Create schema in the selected environment database
    define schema {{database_name}}.{{team_name}}
        comment = 'using JINJA dictionary values'
        data_retention_time_in_days = {{ team.data_retention_days }};

    -- Create roles and grants for this schema
    {{ create_team_roles(team_name) }}

    -- Create PRODUCTS table
    define table {{database_name}}.{{team_name}}.PRODUCTS(
        ITEM_NAME varchar,
        ITEM_ID varchar,
        ITEM_CATEGORY array
    );

    -- Create EMPLOYEES table when enabled
    {% if team.add_employees | default(false) %}
    define table {{database_name}}.{{team_name}}.EMPLOYEES(
        NAME varchar,
        ID int
    )
    comment = 'This table is only created in HR';
    {% endif %}
{% endfor %}
