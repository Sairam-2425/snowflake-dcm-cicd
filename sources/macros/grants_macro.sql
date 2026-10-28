
-- Macro to create standard roles for each team
{% macro create_team_roles(team) %}

    define role {{team}}_DEVELOPER{{env_suffix}};
    define role {{team}}_USAGE{{env_suffix}};

    -- Grant access to the existing environment database
    grant USAGE
        on database {{database_name}}
        to role {{team}}_USAGE{{env_suffix}};

    -- Grant access to the team's schema
    grant USAGE
        on schema {{database_name}}.{{team}}
        to role {{team}}_USAGE{{env_suffix}};

    -- Allow developers to create objects in the team's schema
    grant CREATE DYNAMIC TABLE, CREATE TABLE, CREATE VIEW
        on schema {{database_name}}.{{team}}
        to role {{team}}_DEVELOPER{{env_suffix}};

    -- Set up role hierarchy
    grant role {{team}}_USAGE{{env_suffix}}
        to role {{team}}_DEVELOPER{{env_suffix}};

    grant role {{team}}_DEVELOPER{{env_suffix}}
        to role {{project_owner_role}};

{% endmacro %}
